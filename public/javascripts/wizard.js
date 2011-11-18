var place_id = $('#place_id').val();
var token = $('#token').val();
var access_token = $('#accessToken').val();

var zipCodeVal = true;

/*********************
* Panels
**********************/


var il8nStrings = {
  not_listed_yet: 'Your place is not listed yet!',
  not_listed: 'Your place is ready for listing',
  place_listed: 'Your place is listed. Click here to remove it from the directory',
  form_error: 'Please fix the error on the form first before we can proceed.',
  categories_left: 'more categories must be completed',
  listed: 'Listed',
  preview: 'Preview',
  unpublish: 'Unpublish',
  not_listed_yet_click_to_preview: 'Your place is ready for listing. Click here to preview then publish!'
};

var t = function(key) {
  return il8nStrings[key];
}

var switchPanel = function() {

    // Remove form errors
  if($('.formError').size() > 0) {
    alert(t('form_error'));
    return false;
  }

  _this = $(this);

  $('.wizard-wrapper .panel').hide();
  $(_this.attr('href')).fadeIn('fast');

  $('.section_title').html(_this.attr('title'));

  _this.parent().parent().find('a').removeClass('active');
  _this.addClass('active');

  return false;
};

var switchToPanel = function(target) {
  $('ul#wizard-selector li a[href="' + target + '"]').click();
}

var validatePlace = function(panelStatus) {
  var validCategories = 0;

  // Count valid categories
  if(panelStatus.general) { validCategories++; }
  if(panelStatus.photos) { validCategories++; }
  if(panelStatus.amenities) { validCategories++; }
  if(panelStatus.price) { validCategories++; }
  if(panelStatus.calendar) { validCategories++; }

  var validMarkers = $('.preview-button, #listing-status');

  // If all 5 categories are valid
  if(validCategories == 5) {
    $('.preview-button').attr('rel', '');
    $('.preview-button').attr('data-original-title', '');
    $('.preview-button').attr('disabled', false);

    // Enable the listing-status button/ajax call
    $('#listing-status').attr('rel', 'twipsy');    
    $('#listing-status').attr('disabled', false);
    $('#listing-status').attr('href', '/places/' + $('#place_id').val() + '/preview');

    // If not published, display as preview, otherwise unpublish.
    if($('#place_published').val() == 'false') {
      $('#listing-status').html(t('preview'));      
      $('#listing-status').attr('data-original-title', t('not_listed_yet_click_to_preview'));      
    } else {
      $('#listing-status').html(t('unpublish'));      
      $('#listing-status').attr('data-original-title', t('place_listed'));
    }

  } else {
    validMarkers.attr('disabled', true);
    validMarkers.attr('rel', 'twipsy');
    validMarkers.attr('data-original-title', t('not_listed_yet') + '. ' + (5 - validCategories) + ' ' + t('categories_left') + '!');

    $('#listing-status').attr('href', '#');
  }

  return (validCategories == 5);
}

var validatePanels = function(target) {

  var panelStatus = {};
  var wizard_aside = $('.wizard-aside');
  
  // General Validation
  if($('#place_title').val() && $('#place_max_guests').val() && $('#place_size_sqm').val() && $('#place_description').val() && $('#place_description').val().length >= 20) {
    wizard_aside.find('li#general .indicator img').attr('src', '/images/check.png');
    panelStatus.general = true;
  } else {
    wizard_aside.find('li#general .indicator img').attr('src', '/images/check-disabled.png');
    panelStatus.general = false;
  }

  // Photos
  if($('#photos_list li').size() > 0) {
    wizard_aside.find('li#photos .indicator img').attr('src', '/images/check.png');
    panelStatus.photos = true;
  } else {
    wizard_aside.find('li#photos .indicator img').attr('src', '/images/check-disabled.png');
    panelStatus.photos = false;
  }

  // Price
  if($('#place_price_per_night').val() && $('#place_currency').val() && $('#place_cancellation_policy').val()) {
    wizard_aside.find('li#price .indicator img').attr('src', '/images/check.png');
    panelStatus.price = true;
  } else {
    wizard_aside.find('li#price .indicator img').attr('src', '/images/check-disabled.png');
    panelStatus.price = false;
  }

  panelStatus.amenities = validateAmenitiesPanel();
  panelStatus.calendar = true;

  return validatePlace(panelStatus); 
}

var validateAmenitiesPanel = function(target) {
  var wizard_aside = $('.wizard-aside');
  // Amenities
  var hasAmenity = false;
  $('.amenity input[type=checkbox]').each(function() {
    if($(this).attr('checked') == 'checked') {
      hasAmenity = true;
      wizard_aside.find('li#amenities .indicator img').attr('src', '/images/check.png');
      return hasAmenity;
    }
  });

  if(hasAmenity == false) {
    wizard_aside.find('li#amenities .indicator img').attr('src', '/images/check-disabled.png');    
  }

  return hasAmenity;
}


/*********************
* Wizard General
**********************/

var sendFieldUpdate = function() {
  
  var elem = $(this);
  // Check if we have changed values
  if(elem.attr('data-changed') == "1" && !validateElement(elem)) {
    if(zipCodeVal){
      hideIndicator(elem);
      showIndicator(elem);

      place_id = $("#place_id").val(); // TODO: Quick update for now

      $.ajax({
        type: 'PUT',
        url: '/places/' + place_id + '.json',
        data: $(this).serialize(), 
        success: function() {
          showSavedIndicator(elem);
          elem.attr('data-changed', '0');
        }
      });
    } else {
      showErrorIndicator(elem);
    }
    validatePanels();    
  }
};

var sendCheckBoxUpdate = function() {
  var elem = $(this);
  hideIndicator(elem);
  showIndicator(elem);

  elem.hide();

  var post_data = "";
  var field = $(this).attr("name");
  var value = "1";

  if($(this).attr("checked") == "checked") {
    value = "1";
  } else {
    value = "0";
  }

  post_data = field + "=" + value;
  place_id = $("#place_id").val(); // TODO: Quick update for now

  $.ajax({
    type: 'PUT',
    url: '/places/' + place_id + '.json',
    data: post_data, 
    success: function() {
      hideIndicator(elem);      
      elem.show();
    }
  });
  validateAmenitiesPanel();
};  

var trackChange = function() {
  $(this).attr('data-changed', "1");
};

var validateZipCode = function() {
  var country_id = $('#place_city_id').val();
  var zip = $(this).val();
  if(zip.match(/^\d{6}$/) && country_id == '1') {
    zipCodeVal = true;
  } else if(zip.match(/^\d{5}$/) && country_id == '4065') {
    zipCodeVal = true;
  } else if(country_id == '13984' && zip.match(/^\d{2,}$/)){
    zipCodeVal = true;
  } else {
    zipCodeVal = false;
  }
};

//for minimum and maximum days
var hideShowInputStay = function() {
  var elemName = $(this).attr('id');
  var elemVal = $(this).val();
  var placeInput;

  if(elemName == 'days_minimum_stay') {
    placeInput = $('#place_minimum_stay_days');
  } else {
    placeInput = $('#place_maximum_stay_days');
  }

  if(elemVal == 0) {
    placeInput.show();
    placeInput.find('~ .help-inline').show();    
  } else {
    placeInput.hide();
    placeInput.find('~ .help-inline').hide();    
    field = placeInput.attr("name");
    post_data = field + "=" + '';
    place_id = $("#place_id").val(); // TODO: Quick update for now

    $.ajax({
      type: 'PUT',
      url: '/places/' + place_id + '.json',
      data: post_data 
    });
  }


};

var computeWeeklyMonthlyPay = function() {
  var per_week = $(this).val() * 7;
  var per_month = $(this).val() * 30;
  var total_per_week;
  var total_per_month;
  var currency_sign = $('.currency-sign-id').text();
  total_per_week = Math.floor(per_week * 0.95);
  total_per_month = Math.floor(per_month * 0.95);

  if($(this).val() != 0 || $(this).val() != ''){
    $('#estimated_amount_weekly').html("Based on your daily price, we recommend " + currency_sign + total_per_week);
    $('#estimated_amount_monthly').html("Based on your daily price, we recommend " + currency_sign + total_per_month);
  }
};

function showComputeWeeklyMonthlyPay(elem) {
  var per_week = elem * 7;
  var per_month = elem * 30;
  var total_per_week;
  var total_per_month;
  var currency_sign = $('.currency-sign-id').text();
  total_per_week = Math.floor(per_week * 0.95);
  total_per_month = Math.floor(per_month * 0.95);

  if(elem != 0 || elem != ''){
    $('#estimated_amount_weekly').html("Based on your daily price, we recommend <span class='currency-sign-id'>" + currency_sign + "</span>" + total_per_week);
    $('#estimated_amount_monthly').html("Based on your daily price, we recommend <span class='currency-sign-id'>" + currency_sign + "</span>" + total_per_month);
  }
};


function showHideInitialDefultInput() {
  //check the value of minimum and maximum days
  var place_min = $('#place_minimum_stay_days').val();
  if(place_min == '' || place_min == undefined) {
    $('#place_minimum_stay_days').hide();
    $('select#days_minimum_stay').val('1');
    $('#place_minimum_stay_days').find('~ .help-inline').hide();
  } else {
    $('#place_minimum_stay_days').show();
    $('select#days_minimum_stay').val('0');
    $('#place_minimum_stay_days').find('~ .help-inline').show();
  };

  var place_min = $('#place_maximum_stay_days').val();
  if(place_min == '' || place_min == undefined) {
    $('#place_maximum_stay_days').hide();
    $('select#days_maximum_stay').val('1');
    $('#place_maximum_stay_days').find('~ .help-inline').hide();    
  } else {
    $('#place_maximum_stay_days').show();
    $('select#days_maximum_stay').val('0');
    $('#place_maximum_stay_days').find('~ .help-inline').show();    
  };
  //for pricing text
  var nightPrice = $('#place_price_per_night').val();
  showComputeWeeklyMonthlyPay(nightPrice);
};

/*********************
* Initialize here 
**********************/
$(document).ready(function() {

  // Wizard Selector
  $('ul#wizard-selector li a').die().bind('click', switchPanel);

  // Validation engine
  $('#wizard_form').validationEngine();

  // Character count
  $('#place_title').charCounter(40, {container: "<em></em>",classname: "counter", format: "(%1)"});

  // Do we need a limit on place description?
  //$('#place_description').charCounter(40, {container: "<em></em>",classname: "counter", format: "(%1)"});

  // proof of concept - save on update feature
  $('#wizard_form input[type=text].autosave, #wizard_form textarea.autosave, #wizard_form select.autosave').change(trackChange)
        .blur(sendFieldUpdate);

  $("#wizard_form input[type='checkbox']").change(sendCheckBoxUpdate);

  // Validate the zip code
  $('#place_zip').change(validateZipCode);

  // Place title change
  $('#place_title').change(function() {
    $('h1.title').html($(this).val());
  });  

  // Price per night
  $('#place_price_per_night').change(computeWeeklyMonthlyPay);

  $('#place_currency').change(function() {
    var elem = $(this);

    hideIndicator(elem);
    showIndicator(elem);

    place_id = $("#place_id").val(); // TODO: Quick update for now

    $.ajax({
      type: 'PUT',
      url: '/places/' + place_id + '/update_currency.json',
      data: $(this).serialize(), 
      success: function(data) {
        $(".currency-sign, .currency-sign-id").html(data.currency_sign);
        showSavedIndicator(elem);
      }
    });
  });

  $('ul#wizard-selector li a').click(function(){
    $('#wizard_form').validationEngine('hideAll');
  });

  $("#days_minimum_stay").change(hideShowInputStay);
  $("#days_maximum_stay").change(hideShowInputStay);
  showHideInitialDefultInput();

  $("a[rel=twipsy]").twipsy({
    live:true,
    animate: false
  }).css({'border': '1px solid', 'border-radius' : '5px', 'margin-left': '10px'});

  $('.wizard-aside').waypoint(function(event, direction) {
		$(this).toggleClass('sticky', direction === "down");
		//event.stopPropagation();
	});

});
