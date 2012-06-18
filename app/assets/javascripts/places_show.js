var PlaceShow = {
  initialize: function(opts){
    //*******************************************************************************************
    // INITIALIZERS
    //*******************************************************************************************
    var self = this;
    var isCalendarOpen = false;
    self.initializeSlider();
    self.initializeSharePlace(opts.share_title, opts.share_url, opts.share_id);
    self.inquireModal();

    // Lazy Initialize Map and calendar
    $('a[data-toggle="tab"]').on('shown', function (e) {
      // Lazy load calendar
      if ($(e.target).attr('href') == '#calendar-tab') {
        if (!isCalendarOpen) {
          self.initializeCalendar(opts.cal_events, opts.cal_lastVisibleDay, opts.cal_month);
          isCalendarOpen = true;
        };
      };
      // Lazy load map
      if ($(e.target).attr('href') == '#map-tab') {
        self.initializeMap(opts.map_lat, opts.map_lon, opts.map_cityName, opts.map_countryName);
      }
    });

    if(window.location.hash){
      $('a[href="' + window.location.hash + '"]').tab('show');
    }
  },
  
  //*******************************************************************************************
  // Photo slider
  //*******************************************************************************************
  initializeSlider: function() {
    var slider = $('#photo-slider');
    if(slider.length > 0) {
      slider.tinycarousel({ interval: true, pager: true, animation: false, fading: true });

      $('.extra-paginator').click(function() {
        slider.tinycarousel_move($(this).attr('data-page'));
        return false;
      });
    }    
  },

  //*******************************************************************************************
  // Google Map initialization
  //*******************************************************************************************    
  initializeMap:  function(lat, lon, cityName, countryName) {
    var mapOptions = {
      zoom: 15,
      center: new google.maps.LatLng(lat, lon),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };

    var map = new google.maps.Map(document.getElementById('map'),mapOptions);
	
	var rand = parseFloat((Math.random() * (0.002 - (-.002)) + (-.002)).toFixed(4));
	var circle_lat = lat +rand ;
	var circle_lon = lon +rand ;
    // Add a Circle overlay to the map.
    var circle = new google.maps.Circle({
      map: map,
	  center: new google.maps.LatLng(circle_lat, circle_lon),
	  strokeColor: '#004de8',
      strokeWeight: 1,
      strokeOpacity: 0.62,
      fillColor: '#004de8',
      fillOpacity: 0.27,
      radius: 500 
    });
  },

  //*******************************************************************************************
  // Calendar initialization
  //*******************************************************************************************
  initializeCalendar: function(events, lastVisibleDay, month) {
    $('#first-calendar').fullCalendar({
      header   : {left: 'prev', center: 'title', right: ''},
      editable : false,
      events   : events,         // A URL of a JSON feed that the calendar will fetch Event Objects from
      visEnd   : lastVisibleDay,  // A Date object of the day after the last visible day
      eventRender: PlaceShow.onEventRender,
      viewDisplay: PlaceShow.markFreeDays
    });

    $('#second-calendar').fullCalendar({
      header   : { left: '', center: 'title', right: 'next'},
      editable : false,
      events   : events,         // A URL of a JSON feed that the calendar will fetch Event Objects from
      month    : month,          // The initial month when the calendar loads.
      visStart : false,
      eventRender: PlaceShow.onEventRender,
      viewDisplay: PlaceShow.markFreeDays
    });

    $('.fc-header-left .fc-button-inner').hide();

    $('#first-calendar .fc-header-left .fc-button-prev').click(function() {
      $('#second-calendar').fullCalendar('prev');
      var first_cal = $('#first-calendar').fullCalendar('getDate');
      var cur_date = new Date();
      if (first_cal.getMonth() == cur_date.getMonth()) {
        $('.fc-header-left .fc-button-inner').hide();
      } else{
        $('.fc-header-left .fc-button-inner').show();
      }
    });

    $('#second-calendar .fc-header-right .fc-button-next').click(function() {
      $('#first-calendar').fullCalendar('next');
      $('.fc-header-left .fc-button-inner').show();
    });
    
    $('#first-calendar').fullCalendar('render');
    $('#second-calendar').fullCalendar('render');
  },
  
  markFreeDays: function(){
    $(this).find('.fc-content td').removeClass('free');
    $(this).find('.fc-content td').removeClass('busy');

    events = $(this).fullCalendar('clientEvents');
    var isBusy = function(date){
      for(var i in events){
        var event = events[i];
        if(event.color == "red" && (date.getTime() >= event.start.getTime()) && (date.getTime() <= event.end.getTime())){
          return true;
        }
      }
      return false;
    };

    var today = $(this).fullCalendar('getDate');
    var viewData = $(this).fullCalendar('getView');
    cMonth = today.getMonth();
    cYear = today.getFullYear();
    lYear = parseInt(cYear);

    $(this).find('.fc-day-number').each(function(){
      var cell = $(this).parent().parent();

      if(!cell.hasClass('fc-other-month')){
        lDay = parseInt($(this).text());
        lMonth = parseInt(cMonth);
        lDate = new Date(lYear,lMonth,lDay);
        if(isBusy(lDate)){
          cell.addClass('busy');
        } else {
          cell.addClass('free');
        }
      }
    });
  },

  onEventRender: function(event, element, view){
    if(event.color == 'red'){
      return false;
    }
  },

  //*******************************************************************************************
  // Share Buttons initialization
  //*******************************************************************************************
  initializeSharePlace: function(title, url, id) {
    $('.sharePlace').bookmark({
      sites: ['facebook', 'twitter', 'google'],
      showAllText: 'Show all ({n})',
      title: title,
      hint: 'Share this place',
      url: url //+ ' ' + id
    });    
  },
  
  inquireModal: function(){
    $('#inquire_place').on('shown', function (){
      add_datepicker();
      
      $('#inquiry_date_start_label').datepicker('destroy').datepicker({
        // dateFormat: 'dd/mm/yy',
        dateFormat: 'd M yy',
        minDate: +1,
        altField: "#inquiry_date_start",
        altFormat: 'yy-mm-dd'
      });

      $('.alert-message').remove();
      $("#inquire_form").validationEngine({
        promptPosition : "bottomRight:-10,-10",
        relative: true,
        onValidationComplete: function(form, status){
          if(status){
            $("#inquire_button").button('loading');
            form.validationEngine('detach');
            form.submit();
          }
        }
      });
    });
  }    
}