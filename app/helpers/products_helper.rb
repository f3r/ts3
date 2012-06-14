module ProductsHelper
  def render_overridable_partial(partial, *attr)
    views_path = ::Rails.root.to_s + "/app/views"
    plural_product = SiteConfig.product_class.to_s.pluralize
    specific_path = "products/#{plural_product}"

    if File.exists?("#{views_path}/#{specific_path}/_#{partial}.haml")
      render "#{specific_path}/#{partial}", *attr
    else
      render "products/#{partial}", *attr
    end
  end

  def seo_product_path(product)
    '/bla'
  end

  def product_price(product)
    symbol, amount = product.price(current_currency, product.price_unit)
    "#{current_currency.label}#{amount}"
  end

  def product_price_unit(product)
    t(product.price_unit)
  end
end