module SearchHelper
  def search_results_count(results)
    t("places.search.results", :count => results.count)
  end
end

