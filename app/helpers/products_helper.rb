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

  def seo_city_path(city)
    url_for("/#{city.slug}")
  end

  def seo_product_url(product)
    extra = product.title.dup
    extra.gsub!(/[^\x00-\x7F]+/, '') # Remove anything non-ASCII entirely (e.g. diacritics).
    extra.gsub!(/[^\w_ \-]+/i, '')   # Remove unwanted chars.
    extra.gsub!(/[ \-]+/i, '-')      # No more than one of the separator in a row.
    extra.gsub!(/^\-|\-$/i, '')      # Remove leading/trailing separator.
    extra.downcase!

    city = product.city

    city_product_url(:city => city.slug, :id => "#{product.id}-#{extra}")
  end

  def product_price(product)
    symbol, amount = product.price(current_currency, product.price_unit)
    "#{current_currency.label}#{amount}"
  end

  def product_price_unit(product)
    t(product.price_unit)
  end

  def map_markers_json(results)
    results.collect{|p| {id: p.id, title: p.title, url: seo_product_url(p), lat: p.lat, lon: p.lon}}.to_json
  end

  def primary_photo(product)
    if product.primary_photo
      product.primary_photo
    else
      "https://s3.amazonaws.com/squarestays-static/missing_userpic_200.jpeg"
    end
  end
end