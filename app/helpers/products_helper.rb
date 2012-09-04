module ProductsHelper
  def render_overridable_partial(partial, *attr)
    views_path = ::Rails.root.to_s + "/app/views"
    plural_product = SiteConfig.product_class.to_s.tableize
    specific_path = "products/#{plural_product}"

    if File.exists?("#{views_path}/#{specific_path}/_#{partial}.haml")
      render "#{specific_path}/#{partial}", *attr
    else
      render "products/#{partial}", *attr
    end
  end

  def overridable_partial_defined?(partial)
    views_path = ::Rails.root.to_s + "/app/views"
    plural_product = SiteConfig.product_class.to_s.tableize
    specific_path = "products/#{plural_product}"

    File.exists?("#{views_path}/#{specific_path}/_#{partial}.haml")
  end

  def product_price(product)
    symbol, amount = product.price(current_currency, product.price_unit)
    "#{current_currency.label}#{amount}"
  end

  def product_price_unit(product)
    t(SiteConfig.price_unit)
  end

  def product_status_badge(product)
    if product.published?
      content_tag :span, t("products.listed"), :class => 'label product-status label-success'
    else
      content_tag :span, t("products.invisible"), :class => 'label product-status'
    end
  end

  def map_markers_json(results)
    results.reject{|p| !p.geocoded? }.collect{|p| {id: p.id, title: p.title, url: seo_product_url(p), lat: p.lat, lon: p.lon}}.to_json
  end

  def can_review?(product, user)
    user && !(user == product.user) && !Review.exists?(:user_id => user.id, :product_id => product.id) && product.has_any_paid_transactions?(user)
  end

  def show_product_panoramas?(product)
    SiteConfig.panoramas? && product.panoramas.any?
  end

  def stars(n)
    n = 0 if n < 0
    n = 5 if n > 5
    blank = 5 - n
    html = n.times.collect{ content_tag(:i, '', :class => 'icon-star big') }.join
    html << blank.times.collect{ content_tag(:i, '', :class => 'icon-star-empty') }.join
    content_tag :div, html.html_safe, :class => 'stars', :title => "#{n}/5"
  end

  def custom_field_input(cf, resource)
    field_name  = "listing[custom_fields][#{cf.name}]"
    field_value = resource.custom_fields[cf.name]
    field_id    = "custom_field_#{cf.name}"

    validation_klasses = []
    validation_klasses << 'required' if cf.required?
    validation_klasses << 'custom[integer]' if cf.integer?
    validation_klasses << cf.validations if cf.validations.present?
    klasses = "validate[#{validation_klasses.join(',')}] "

    html = case cf.type
             when :dropdown, :yes_no, :yes_no_text
               select_tag field_name, options_for_select(cf.options, field_value), {:include_blank => true, :id => field_id, :class => klasses}
             when :checkbox
               check_box_tag field_name, true, field_value, :id => field_id, :class => klasses
             else
               text_field_tag field_name, field_value, :id => field_id, :class => klasses
           end

    if cf.yes_no_text? and cf.more_info_label.present?
      extra_field_name = "listing[custom_fields][#{cf.name_extra}]"
      extra_field_value = resource.custom_fields[cf.name_extra]
      extra_field_id    = "custom_field_#{cf.name_extra}"
      #TODO: Clean the below a bit
      html << content_tag(:span, :id => "cf_extra_#{extra_field_id}") do
        "&nbsp;&nbsp;#{cf.more_info_label}&nbsp;&nbsp;#{text_field_tag(extra_field_name, extra_field_value, :id => extra_field_id)}".html_safe
      end

      html << javascript_tag do
        %Q{
           $(document).ready(function(){
                $("##{field_id}").live('change', function(){
                          if($(this).val() == 1) {
                            $("#cf_extra_#{extra_field_id}").show();
                          }
                          else {
                            $("#cf_extra_#{extra_field_id}").hide();
                          }
                    });
                $("##{field_id}").trigger('change');
            });

        }.html_safe
      end
    end

    if cf.hint.present?
      if cf.type == :checkbox
        html = content_tag(:label, :class => 'checkbox') do
          "#{html} <span class='checkbox-help-block'>#{cf.hint}</span>".html_safe
        end
      else
        html << content_tag(:p, cf.hint, :class => 'help-block')
      end
    end

    html
  end

  def custom_field_value(cf, resource)
    field_value = resource.custom_fields[cf.name]
    value = case cf.type
              when :dropdown
                field_value.humanize if field_value
              when :checkbox
                field_value ? 'Yes' : 'No'
              when :yes_no
                CustomField.YES_NO_HASH.keys[field_value.to_i] if field_value.present? and field_value.match(/^\d+$/)
              when :yes_no_text
                if field_value.present? and field_value.match(/^\d+$/)
                  value = CustomField.YES_NO_HASH.keys[field_value.to_i] if field_value.present? and field_value.match(/^\d+$/)
                  if field_value.to_i == 1 and cf.more_info_label.present?
                    more_info_value = resource.custom_fields[cf.name_extra]
                    value = value + " (#{more_info_value})" if more_info_value.present?
                  end
                  value
                end
              else
                field_value
            end
    value || '-'
  end

  def wizard_step_class(wizard, step)
    if wizard.current_step?(step)
      'active'
    elsif wizard.completed_step?(step)
      'completed'
    elsif wizard.enabled_step?(step)
      'enabled'
    else
      'disabled'
    end
  end
end
