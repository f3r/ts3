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

  def wizard_step_defined?(tab_name)
    views_path = ::Rails.root.to_s + "/app/views"
    plural_product = SiteConfig.product_class.to_s.tableize
    specific_path = "products/#{plural_product}"

    File.exists?("#{views_path}/#{specific_path}/wizard_tabs/_step_#{tab_name}.haml")
  end

  def wizard_tabs
    unless @wizard_tabs
      @wizard_tabs = []
      @wizard_tabs << :general
      @wizard_tabs << :custom_fields if CustomField.any?
      @wizard_tabs << :photos    if wizard_step_defined?(:photos) && SiteConfig.photos?
      @wizard_tabs << :panoramas if wizard_step_defined?(:panoramas) && SiteConfig.panoramas?
      @wizard_tabs << :traits    if wizard_step_defined?(:traits) && AmenityGroup.any?
      @wizard_tabs << :pricing   if wizard_step_defined?(:pricing)
      @wizard_tabs << :address   if wizard_step_defined?(:address)
      #tabs << :calendar if SiteConfig.calendar?
    end
    @wizard_tabs
  end

  def product_price(product)
    symbol, amount = product.price(current_currency, product.price_unit)
    "#{current_currency.label}#{amount}"
  end

  def product_price_unit(product)
    t(SiteConfig.price_unit)
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
    field_value = resource.custom_values[cf.name]
    field_id    = "custom_field_#{cf.name}"
    html = case cf.type
    when :dropdown
      select_tag field_name, options_for_select(cf.options, field_value), {:include_blank => !cf.required?, :id => field_id }
    when :checkbox
      check_box_tag field_name, true, field_value, :id => field_id
    else
      text_field_tag field_name, field_value, :id => field_id
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
end
