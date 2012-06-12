$ ->

  #############################################################################
  # Parse the JSON from places into a string (so we can pin it)
  #############################################################################
  createMarkerObjectsFromString = (places) ->
    data = places.replace(/&quot;/g,'"')
    $.parseJSON(data)

  #############################################################################
  # Add the google pins from places on the map
  #############################################################################
  createMarkers = (map,places) ->
    # Placing markers in Map
    for place in places
      myLatlng = new google.maps.LatLng(place.lat,place.lon)
      marker = new google.maps.Marker
        position: myLatlng
        title: @title
        data: @id

      # Redirect to page when clicking on marker
      google.maps.event.addListener marker, 'click', -> performMarkerEvent(@)
    
      marker.setMap map
      map.addMarker marker

  #############################################################################
  # Set the boundary values on the map
  #############################################################################
  setBoundsValues = (map) ->
    latLngBounds = map.getBounds()
      
    if !latLngBounds.isEmpty
      southWest = latLngBounds.getSouthWest
      northEast = latLngBounds.getNorthEast

      minLat = southWest.lat
      minLng = southWest.lng
      maxLat = northEast.lat
      maxLng = northEast.lng
      
      # setting boundary values
      $('#min_lat').val(minLat)
      $('#max_lat').val(maxLat)
      $('#min_lng').val(minLng)
      $('#max_lng').val(maxLng)
      
      # Only load when no current request is pending
      if $('.results > #search-load-indicator').length == 0
        pull_data()

  #############################################################################
  # Redirect to place details when clicking on Marker
  #############################################################################
  performMarkerEvent = (place) ->
    title = place.title
    id    = place.data
    if id != ''
      $.ajax
        url: '/get_place_path'
        type:'POST'
        data:
          place_id: id
        success: (data) ->
          if data.stat == 'success'
            $(location).attr('href', data.path)

  GMaps =
  initialize = (places) ->
    
      google.maps.Map.prototype.markers = []
      
      google.maps.Map.prototype.addMarker = (marker) ->
        @markers[@markers.length] = marker
    
      google.maps.Map.prototype.getMarkers = -> @markers
      
      google.maps.Map.prototype.clearMarkers = ->
        for i in [0..@markers.length]
          @markers[i].setMap(null)
      
      parentLocationLat = places[0].lat
      parentLocationLng = places[0].lon

      # Map options
      myOptions =
        center: new google.maps.LatLng(parentLocationLat, parentLocationLng)
        zoom: 12
        mapTypeControl: false
        zoomControlOptions:
          position: google.maps.ControlPosition.TOP_LEFT
        mapTypeId: google.maps.MapTypeId.ROADMAP
        streetViewControl: false

      # Initializing Map
      map = new google.maps.Map(document.getElementById('search_map'), myOptions)
    
      createMarkers(map,places)
      
      # Doing location search when the user pans through the Map
      google.maps.event.addListener map, 'dragend', -> setBoundsValues(map)
      
      # Doing location search when the user performing zoom action
      google.maps.event.addListener map, 'zoom_changed', -> setBoundsValues(map)