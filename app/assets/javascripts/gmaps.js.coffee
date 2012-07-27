initialMarkerCount = 0
initial_prompt = false
GMaps =
  initialize : (initialLat, initialLng) ->
    initial_prompt = true
    initialMarkerCount = 1
    google.maps.Map.prototype.markers = []

    google.maps.Map.prototype.addMarker = (marker) ->
      @markers[@markers.length] = marker

    google.maps.Map.prototype.getMarkers = -> @markers

    google.maps.Map.prototype.clearMarkers = ->
      for marker in @markers
        marker.setMap(null)

    parentLocationLat = parentLocationLng = 0

    initialLng ||= 0
    initialLng ||= 0

    myOptions =
      center: new google.maps.LatLng(initialLat, initialLng)
      zoom: 12
      mapTypeControl: false
      zoomControlOptions:
        position: google.maps.ControlPosition.TOP_LEFT
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false

    @map = new google.maps.Map(document.getElementById('search_map'), myOptions)
    #@bounds = new google.maps.LatLngBounds()

    google.maps.event.addListener @map, 'dragend',      -> GMaps.setBoundsValues()
    google.maps.event.addListener @map, 'zoom_changed', -> GMaps.setBoundsValues()

  createMarkerObjectsFromString : (products) ->
    data = products.replace(/&quot;/g,'"')
    $.parseJSON(data)

  createMarkers : (products, status) ->
    
    if status
      initialMarkerCount = 1;
    for product in products
      image = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="+initialMarkerCount+"|F27629|2D2D2D";
      
      myLatlng = new google.maps.LatLng(product.lat, product.lon)
      marker = new google.maps.Marker
        position: myLatlng
        icon: image,
        title: product.title
        data:
          id: product.id
          url: product.url

      google.maps.event.addListener marker, 'click', -> GMaps.performMarkerEvent(@)

      marker.setMap @map
      @map.addMarker marker
      initialMarkerCount++;
      #@bounds.extend myLatlng
    #@map.fitBounds(@bounds)

  setBoundsValues : ->
    latLngBounds = @map.getBounds()
    if $('#redo_map').is(':checked')
      if !latLngBounds.isEmpty()
        southWest = latLngBounds.getSouthWest()
        northEast = latLngBounds.getNorthEast()

        minLat = southWest.lat()
        minLng = southWest.lng()
        maxLat = northEast.lat()
        maxLng = northEast.lng()

        $('#search_min_lat').val(minLat)
        $('#search_max_lat').val(maxLat)
        $('#search_min_lng').val(minLng)
        $('#search_max_lng').val(maxLng)

        if $('.results > #search-load-indicator').length == 0
          PlaceFilters.search()
    else
      if initial_prompt == true
        initial_prompt = false
        $('#first_time_map_question').show();
        $("#first_time_map_question").delay(12800).fadeOut(800);
      else
        $('#first_time_map_question').hide();

  # Just killed the server method
  performMarkerEvent : (product) ->
    title = product.title
    data  = product.data
    property = "#property_"+data.id;
    
    $(property).animate({backgroundColor: "#A5D6E5"}, 7000 , -> $("#property_"+data.id).css({backgroundColor: "#FFFFFF"}));
    
    $('html,body').animate({scrollTop: $(property).offset().top - 160}, 1500);
      
  clearMarkers : ->
    @map.clearMarkers() if @map;

window.GMaps = GMaps