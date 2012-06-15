module SearchHelper
  def sort_options
  	@search.sort_options
  end

  def search_results_count(results)
    t("products.search.results", :count => results.count)
  end
end

