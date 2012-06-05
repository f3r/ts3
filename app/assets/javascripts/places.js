// var pull_data = function() {
//   alert('submitting');
//   $(".results").append("<span id='search-load-indicator'><img src='/assets/loading.gif' alt='loading...' /></span>");
//   $("#search_results").css('opacity', '.3');
//   $("#search_bar form").submit();
  // $(".results").append("<span id='search-load-indicator'><img src='/assets/loading.gif' alt='loading...' /></span>");
  // $('html, body').animate({scrollTop: 0}, '1000');
  // $("#search_results").css('opacity', '.3');
  // $('#place_result_pages .from_index').html('false');
  // $('#place_result_pages .page_num').html(1);  
  // $('#custom-alerts button.save-search').attr("disabled", "disabled");
  // 
  // var place_type_ids = new Array;
  // $.each($("#types-list input"), function() {
  //   if ($(this).is(":checked")) {
  //     place_type_ids.push($(this).val());
  //   }
  // });
  // 
  // $.ajax({
  //   url: '/places/search',
  //   data: {
  //     guests: $("#guests").val(),
  //     sort: $("#sort").val(),
  //     min_price: $("#min_price").html(),
  //     max_price: $("#max_price").html(),
  //     currency: $('#currency').val(),
  //     check_in: $('#check_in').val(),
  //     check_out: $('#check_out').val(),
  //     place_type_ids: place_type_ids,
  //     city_id: $('#city_id').val()
  //   },
  //   success: function(data) {
  //     $('.results > #search-load-indicator').remove();
  //     $('#search_results').css('opacity', '1');
  // 
  //     $("#search_results").html(data.place_data);
  // 
  //     $("#num_search_results .results_count").html(data.results);
  // 
  //     $("#types-list").html(data.place_filters);
  //     $("#save_search").html(data.save_search);
  // 
  //     if ($("#disp-gallery").hasClass('current')) {
  //       $(".show-grid").show();
  //       $(".list-display").hide();
  //     } else {
  //       $(".list-display").show();
  //       $(".show-grid").hide();
  //     }
  //     $('#place_result_pages .current_page').html(data.current_page);
  //     $('#place_result_pages .total_page').html(data.total_pages);
  //     $('#custom-alerts button.save-search').removeAttr("disabled");
  //   }
  // });
  // return false;
// };

PlaceFilters = {
  initialize: function(containerId){
    var container = $(containerId);

    $("#new_search")
      .bind('ajax:complete', PlaceFilters.loadingIndicatorOff);
//      .bind('ajax:beforeSend', loadingIndicatorOn)

    // Top filters
    $("#search_guests, #search_sort_by").change(PlaceFilters.search);

    // var minPrice = opts['min_price'],
    //     maxPrice = opts['max_price'],
    //     initialMinPrice = opts['initial_min_price'] || minPrice,
    //     initialMaxPrice = opts['initial_max_price'] || maxPrice;
    // 
    // // Initialize Price Sliders
    // $("#price-slider").slider({
    //   range: true,
    //   min: minPrice,
    //   max: maxPrice,
    //   values: [initialMinPrice, initialMaxPrice],
    //   step: 100,
    //   slide: function( event, ui ) {
    //     $("#min_price").html(ui.values[0]);
    //     $("#max_price").html(ui.values[1]);
    //   },
    //   change: function() {
    //     pull_data();
    //   }
    // });
    
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
    
    function nearBottomOfPage() {
      return $(window).scrollTop() > $(document).height() - $(window).height() - 200;
    }

    function lastPage() {
      return $('#search_current_page').val() >= $('#search_total_pages').val();
    }
    
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

$(function() {
  var loading = false;

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
});
