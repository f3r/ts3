PlaceFilters = {
  initialize: function(containerId){
    var container = $(containerId);

    $("#new_search").bind('ajax:complete', PlaceFilters.loadingIndicatorOff);

    // Top filters
    $("#search_guests, #search_sort_by").change(PlaceFilters.search);
    
    // Initialize the date pickers
    $('.check-in-picker, .check-out-picker').datepicker('destroy').datepicker({
      dateFormat: 'yy-mm-dd',
      minDate: +1,
      onSelect: function(selectedDate) {
        // we only refresh results if both calendar pickers are not empty
        var checkin  = $('.check-in-picker').val();
        var checkout = $('.check-out-picker').val();
        if ((checkin != "") && (checkout != "")) {
          PlaceFilters.search();
        }

        var me = $(this);
        var who = me.attr("data-date");
        var instance = me.data("datepicker");

        var date = $.datepicker.parseDate(
              instance.settings.dateFormat ||
              $.datepicker._defaults.dateFormat,
              selectedDate, instance.settings);

        if (who == 'from') {
          from = me.next();
          from.datepicker("option", "minDate", date);
        } else {
          to = me.prev();
          to.datepicker("option", "maxDate", date);
        }
      }
    });

    // $("#types-list input").live('click', function() {
    //   pull_data();
    // });

    // Sticky filters
    $(".search-aside-wrapper").height($(".search-aside").height());
    $(".search-bar-wrapper").height($(".search-bar").height());

    $('.search-bar-wrapper, .search-aside-wrapper').waypoint(function(event, direction) {
      $(this).children().toggleClass('sticky', direction === "down");
      event.stopPropagation();
    }, {offset: 60});  // NOTE: when you change this, goto application.css.less -> .sticky and change top attr

    this.initializeViews();
    this.initializeScroll();
  },
  search: function(){
    $('html, body').animate({scrollTop: 0}, '1000');
    PlaceFilters.loadingIndicatorOn();
    $('#submitted_action').val('filter');
    $('#search_current_page').val(1);
    $('#new_search').submit();
  },
  seeMore: function(){
    $('#submitted_action').val('see_more');
    var page = parseInt($('#search_current_page').val());
    page++;
    $('#search_current_page').val(page);

    $('#see_more_load_indicator').show();
    $('#new_search').submit();
  },
  initializeViews: function(){
    $("#disp-gallery").click(function() {
      $(".show-grid").show();
      $(".list-display").hide();
      $(this).addClass('current');
      $("#disp-list").removeClass('current');
      return false;
    });

    $("#disp-list").click(function() {
      $(".list-display").show();
      $(".show-grid").hide();
      $(this).addClass('current');
      $("#disp-gallery").removeClass('current');
      return false;
    });
  },
  initializeScroll: function(){
    var nearBottomOfPage = function() {
      return $(window).scrollTop() > $(document).height() - $(window).height() - 200;
    };

    var lastPage = function() {
      return $('#search_current_page').val() >= $('#search_total_pages').val();
    };
    
    // Endless scroll
    $(window).scroll(function() {
      if (PlaceFilters.loading) {
        return;
      }
    
      if(nearBottomOfPage() && !lastPage()) {
        PlaceFilters.seeMore();
      }
    });
  },
  loadingIndicatorOn: function(){
    PlaceFilters.loading = true;
    $('#search_load_indicator').show();
    $("#search_results").css('opacity', '.3'); 
  },
  loadingIndicatorOff: function(){
    PlaceFilters.loading = false;
    $('.results > #search-load-indicator').remove();
    $('#see_more_load_indicator').hide();
    $('#search_load_indicator').hide();
    $('#search_results').css('opacity', '1');
  }
}
