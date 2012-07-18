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

  def map_markers_json(results)
    results.reject{|p| !p.geocoded? }.collect{|p| {id: p.id, title: p.title, url: seo_product_url(p), lat: p.lat, lon: p.lon}}.to_json
  end

  def can_review?(product, user)
    user && !(user == product.user) && !Review.exists?(:user_id => user.id, :product_id => product.id) && product.has_any_paid_transactions?(user)
  end

  def stars(n)
    n = 0 if n < 0
    n = 5 if n > 5
    blank = 5 - n
    html = n.times.collect{ content_tag(:i, '', :class => 'icon-star big') }.join
    html << blank.times.collect{ content_tag(:i, '', :class => 'icon-star-empty') }.join
    content_tag :div, html.html_safe, :class => 'stars', :title => "#{n}/5"
  end
end
