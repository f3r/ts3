var pull_data = function() {
  $(".results").append("<span id='search-load-indicator'><img src='/assets/loading.gif' alt='loading...' /></span>");
  $('html, body').animate({scrollTop: 0}, '1000');
  $("#search_results").css('opacity', '.3');
  $('#place_result_pages .from_index').html('false');
  $('#place_result_pages .page_num').html(1);

  var place_type_ids = new Array;
  $.each($("#types-list input"), function() {
    if ($(this).is(":checked")) {
      place_type_ids.push($(this).val());
    }
  });

  $.ajax({
    url: '/places/search',
    data: {
      guests: $("#guests").val(),
      sort: $("#sort").val(),
      min_price: $("#min_price").html(),
      max_price: $("#max_price").html(),
      currency: $('#currency').val(),
      check_in: $('#check_in').val(),
      check_out: $('#check_out').val(),
      place_type_ids: place_type_ids,
      city_id: $('#city_id').val()
    },
    success: function(data) {
      $('.results > #search-load-indicator').remove();
      $('#search_results').css('opacity', '1');

      $("#search_results").html(data.place_data);

      $("#num_search_results .results_count").html(data.results);

      $("#types-list").html(data.place_filters);

      if ($("#disp-gallery").hasClass('current')) {
        $(".show-grid").show();
        $(".list-display").hide();
      } else {
        $(".list-display").show();
        $(".show-grid").hide();
      }
      $('#place_result_pages .current_page').html(data.current_page);
      $('#place_result_pages .total_page').html(data.total_pages);
    }
  });
  return false;
};

PlaceFilters = {
  initialize: function(minPrice, maxPrice){

    // Initialize Price Sliders
    $("#price-slider").slider({
      range: true,
      min: minPrice,
      max: maxPrice,
      values: [minPrice, maxPrice],
      step: 100,
      slide: function( event, ui ) {
        $("#min_price").html(ui.values[0]);
        $("#max_price").html(ui.values[1]);
      },
      change: function() {
        pull_data();
      }
    });
    
    // Initialize the date pickers
    $('.check-in-picker').datepicker();   
    $('.check-out-picker').datepicker();   

    // Top filters
    $("#guests, #sort").change(function() {
      pull_data();
    });

    $("#types-list input").live('click', function() {
      pull_data();
    });
  }
}



String.prototype.human_titleize = function() {
  var arr = new Array();
  $.each(this.split('_'), function(str) {
    arr.push(this.charAt(0).toUpperCase() + this.slice(1));
  });

  return arr.join(' ');
};

$('.check-in-picker, .check-out-picker').datepicker('destroy').datepicker({
  dateFormat: 'yy-mm-dd',
  minDate: +1,
  onSelect: function(selectedDate) {

    // we only refresh results if both calendar pickers are not empty
    var checkin  = $('.check-in-picker').val();
    var checkout = $('.check-out-picker').val();
    
    if ((checkin != "") && (checkout != "")) {
      pull_data();
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

$(function() {
  var loading = false;

  function nearBottomOfPage() {
    return $(window).scrollTop() > $(document).height() - $(window).height() - 200;
  }

  function lastPage() {
    return $('#place_result_pages .current_page').text() == $('#place_result_pages .total_page').text();
  }
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
  
  $(window).scroll(function() {
    if (loading) {
      return;
    }

    if(nearBottomOfPage() && !lastPage()) {
      loading = true;
      page = parseInt($('#place_result_pages .page_num').text());
      page++;
      if($('#place_result_pages .from_index').text() == 'true') {
        $.ajax({
          url: '/places?page=' + page,
          type: 'get',
          dataType: 'script',
          beforeSend: function() {
            $('.loading').show();
          },
          success: function() {
            // $(window).sausage('draw');
            $('#place_result_pages .page_num').html(page);
            loading = false;
            $('.loading').hide();
          }
        });
      } else {
        page = parseInt($('#place_result_pages .page_num').text());
        page++;
         var place_type_ids = new Array;
          $.each($("#types-list input"), function() {
            if ($(this).is(":checked")) {
              place_type_ids.push($(this).val());
            }
          });

          $.ajax({
            url: '/places/search',
            data: {
              guests: $("#guests").val(),
              sort: $("#sort").val(),
              min_price: $("#min_price").html(),
              max_price: $("#max_price").html(),
              currency: $('#currency').val(),
              check_in: $('#check_in').val(),
              check_out: $('#check_out').val(),
              place_type_ids: place_type_ids,
              city_id: $('#city_id').val(),
              page: page
            },
            beforeSend: function() {
              $('.loading').show();
            },
            success: function(data) {
              $("#search_results").append(data.place_data);
              $("#num_search_results .results_count").html(data.results);

              $("#types-list").html(data.place_filters);

              if ($("#disp-gallery").hasClass('current')) {
                $(".show-grid").show();
                $(".list-display").hide();
              } else {
                $(".list-display").show();
                $(".show-grid").hide();
              }
              $('#place_result_pages .from_index').html('false');
              $('#place_result_pages .page_num').html(page);
              $('#place_result_pages .current_page').html(data.current_page);
              $('#place_result_pages .total_page').html(data.total_pages);
              // $(window).sausage('draw');
              loading = false;
              $('.loading').hide();
            }
          });
      }
    }
  });

  // $(window).sausage();
});
