GMaps =
  initialize : (products) ->
    google.maps.Map.prototype.markers = []

    google.maps.Map.prototype.addMarker = (marker) ->
      @markers[@markers.length] = marker

    google.maps.Map.prototype.getMarkers = -> @markers

    google.maps.Map.prototype.clearMarkers = ->
      for marker in @markers
        marker.setMap(null)

    parentLocationLat = parentLocationLng = 0
    if products.length is not 0
      parentLocationLat = products[0].lat
      parentLocationLng = products[0].lon

    myOptions =
      center: new google.maps.LatLng(parentLocationLat, parentLocationLng)
      zoom: 12
      mapTypeControl: false
      zoomControlOptions:
        position: google.maps.ControlPosition.TOP_LEFT
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false

    @map = new google.maps.Map(document.getElementById('search_map'), myOptions)

    GMaps.createMarkers(products)
    google.maps.event.addListener @map, 'dragend',      -> GMaps.setBoundsValues()
    google.maps.event.addListener @map, 'zoom_changed', -> GMaps.setBoundsValues()

  createMarkerObjectsFromString : (products) ->
    data = products.replace(/&quot;/g,'"')
    $.parseJSON(data)

  createMarkers : (products) ->
    for product in products
      myLatlng = new google.maps.LatLng(product.lat, product.lon)
      marker = new google.maps.Marker
        position: myLatlng
        title: product.title
        data:
          id: product.id
          url: product.url

      google.maps.event.addListener marker, 'click', -> GMaps.performMarkerEvent(@)

      marker.setMap @map
      @map.addMarker marker

  setBoundsValues : ->
    latLngBounds = @map.getBounds()

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

  # Just killed the server method
  performMarkerEvent : (product) ->
    title = product.title
    data  = product.data
    $(location).attr('href', product.data.url)

  clearMarkers : ->
    @map.clearMarkers();

window.GMaps = GMaps