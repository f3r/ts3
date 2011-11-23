var place_id = $('#place_id').val();
var token = $('#token').val();
var access_token = $('#accessToken').val();
var zipCodeVal = true;
var firstLoad = true;

var RATE_DISCOUNT_PER_WEEK = 0.95;
var RATE_DISCOUNT_PER_MONTH = 0.95;

/*********************
* Panels
**********************/


var il8nStrings = {
  not_listed_yet: 'Your place is not listed yet!',
  not_listed: 'Your place is ready for listing',
  place_listed: 'Your place is listed. Click here to remove it from the directory',
  form_error: 'Please fix the error on the form first before we can proceed.',
  cannot_preview: 'Sorry. You have to fill up the necessary info before you can preview',
  categories_left: 'more categories must be completed',
  listed: 'Listed',
  preview: 'Preview',
  unpublish: 'Unpublish',
  invisible: 'Invisible',
  not_listed_yet_click_to_preview: 'Your place is ready for listing. Click here to preview then publish!',
  based_on_your_daily_price: "Based on your daily price, we recommend "
};

var t = function(key) {
  return il8nStrings[key];
}

var switchPanel = function() {

  var _panelStatus = validatePanels();
  var switchMe = true;
  var _this = $(this);

  // First, Check the current panel if it is valid
  switch(currentPanel()) {
    case '#1':
      switchMe = _panelStatus.general;
      break;
    case '#2':
      switchMe = _panelStatus.photos;
      break;
    case '#3':
      switchMe = _panelStatus.amenities;
      break;
    case '#4':
      switchMe = _panelStatus.price;
      break;      
    case '#5':
      switchMe = _panelStatus.calendar;
      break;
    default:
      break;
  }

  // Second, Also check the target panel if it is valid then allow.

  /*
  switch(_this.attr('href')) {
    case '#1':
      if(_panelStatus.general) { switchMe = true };
      break;
    case '#2':
      if(_panelStatus.photos) { switchMe = true };
      break;
    case '#3':
      if(_panelStatus.amenities) { switchMe = true };
      break;
    case '#4':
      if(_panelStatus.price) { switchMe = true };
      break;      
    case '#5':
      if(_panelStatus.calendar) { switchMe = true };
      break;
    default:
      break;
  }
  */

  if(switchMe) {
    $('.wizard-wrapper .panel').hide();
    $(_this.attr('href')).fadeIn('fast');

    $('.section_title').html(_this.attr('title'));

    _this.parent().parent().find('a').removeClass('active');
    _this.addClass('active');

  } else {
    if(firstLoad == false) {
      alert(t('form_error')); 
    } else {
      firstLoad = false;
    }
  }

  return false;
};

var currentPanel = function() {
  return $('ul#wizard-selector li a[class=active]').attr('href');
}

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
      $('#listing-status').html(t('invisible'));      
      $('#listing-status').attr('data-original-title', t('not_listed_yet_click_to_preview'));

      // on mouseover make it preview
      $('#listing-status').hover(function() {
        $('#listing-status').html(t('preview'));        
      }, function() {
        $('#listing-status').html(t('invisible'));  
      });

    } else {
    
      $('#listing-status').html(t('listed')); 

      $('#listing-status').hover(function() {
        $('#listing-status').html(t('preview'));        
      }, function() {
        $('#listing-status').html(t('listed'));
      });

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
  var wizard_aside = $('.wizard-aside');

  var panelErrors = panelStatuses(target);
  
  // General Validation
  if(panelErrors.general) {
    wizard_aside.find('li#general .indicator img').attr('src', '/images/check.png');
  } else {
    wizard_aside.find('li#general .indicator img').attr('src', '/images/check-disabled.png');
  }

  // Photos
  if(panelErrors.photos) {
    wizard_aside.find('li#photos .indicator img').attr('src', '/images/check.png');
  } else {
    wizard_aside.find('li#photos .indicator img').attr('src', '/images/check-disabled.png');
  }

  // Price
  if(panelErrors.price) {
    wizard_aside.find('li#price .indicator img').attr('src', '/images/check.png');
  } else {
    wizard_aside.find('li#price .indicator img').attr('src', '/images/check-disabled.png');
  }

  validatePlace(panelErrors); 
  return panelErrors;
}

var panelStatuses = function(target) {

  var errors = {};

  // General errors
  errors.general = ($('#place_title').val() != "" && $('#place_max_guests').val() != "" && $('#place_place_size').val() != "" && $('#place_description').val() != "" && $('#place_description').val().length >= 20);

  // For a better UX. Highlight those fields.
  if($('#place_title').val() == "") { $('#place_title').addClass('error'); } else { $('#place_title').removeClass('error');  }
  if($('#place_max_guests').val() == "") { $('#place_max_guests').addClass('error'); } else { $('#place_max_guests').removeClass('error'); }
  if($('#place_place_size').val() == "") { $('#place_place_size').addClass('error'); } else { $('#place_place_size').removeClass('error'); }
  if($('#place_description').val() == "") { $('#place_description').addClass('error'); } else {  $('#place_description').removeClass('error'); }
  if($('#place_description').val().length >= 20) { $('#place_description').addClass('error'); } else { $('#place_description').removeClass('error'); } 

  // Photos
  errors.photos = ($('#photos_list li').size() > 0);

  // Price
  errors.price = ($('#place_price_per_night').val() != "" && $('#place_currency').val() != "" && $('#place_cancellation_policy').val() != "");

  if($('#place_price_per_night').val() == "") { $('#place_price_per_night').addClass('error'); } else { $('#place_price_per_night').removeClass('error');  }
  if($('#place_currency').val() == "") { $('#place_currency').addClass('error'); } else { $('#place_currency').removeClass('error'); }
  if($('#place_cancellation_policy').val() == "") { $('#place_cancellation_policy').addClass('error'); } else { $('#place_cancellation_policy').removeClass('error'); }

  // Amenities
  errors.amenities = validateAmenitiesPanel();

  // Calendar
  errors.calendar = true;

  return errors;
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

var validatePreview = function() {

  var _panelStatus = validatePanels();

  if(_panelStatus.general && _panelStatus.photos && _panelStatus.amenities && _panelStatus.price && _panelStatus.calendar) {
    return true;
  } else {
    alert(t('cannot_preview'));    
    return false;
  }

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

var sendPlaceSizeUpdate = function () {

  var elem = $(this);
  var put_data;
  // Check if we have changed values
  if(elem.attr('data-changed') == "1" && !validateElement(elem)) {

    hideIndicator(elem);
    showIndicator(elem);

    place_id = $("#place_id").val(); // TODO: Quick update for now

    put_data = 'place[size]='+ $('#place_place_size').val() + "&" + $('#place_size_unit').serialize();

    $.ajax({
      type: 'PUT',
      url: '/places/' + place_id + '.json',
      data: put_data, 
      success: function() {
        showSavedIndicator(elem);
        elem.attr('data-changed', '0');
      }
    });

    validatePanels();    
  }

}

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
  validatePanels();   
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
  total_per_week = Math.floor(per_week * RATE_DISCOUNT_PER_WEEK);
  total_per_month = Math.floor(per_month * RATE_DISCOUNT_PER_MONTH);

  if($(this).val() != 0 || $(this).val() != ''){
    $('#estimated_amount_weekly').html(t('based_on_your_daily_price') + "<span class='currency-sign-id'>" + currency_sign + "</span>" + total_per_week);
    $('#estimated_amount_monthly').html(t('based_on_your_daily_price') + "<span class='currency-sign-id'>" + currency_sign + "</span>" + total_per_month);
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
    $('#estimated_amount_weekly').html(t('based_on_your_daily_price') + "<span class='currency-sign-id'>" + currency_sign + "</span>" + total_per_week);
    $('#estimated_amount_monthly').html(t('based_on_your_daily_price') + "<span class='currency-sign-id'>" + currency_sign + "</span>" + total_per_month);
  }
};


function showHideInitialDefaultInput() {
  //check the value of minimum and maximum days
  var place_min = $('#place_minimum_stay_days').val();
  if(place_min == '' || place_min == undefined || place_min == '0') {
    $('#place_minimum_stay_days').hide();
    $('select#days_minimum_stay').val('1');
    $('#place_minimum_stay_days').find('~ .help-inline').hide();
  } else {
    $('#place_minimum_stay_days').show();
    $('select#days_minimum_stay').val('1');
    $('#place_minimum_stay_days').find('~ .help-inline').show();
  };

  var place_min = $('#place_maximum_stay_days').val();
  if(place_min == '' || place_min == undefined || place_min == '0') {
    $('#place_maximum_stay_days').hide();
    $('select#days_maximum_stay').val('1');
    $('#place_maximum_stay_days').find('~ .help-inline').hide();    
  } else {
    $('#place_maximum_stay_days').show();
    $('select#days_maximum_stay').val('30');
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

  $('#wizard_form input[type=text].autosave_place_unit,  #wizard_form select.autosave_place_unit').change(trackChange)
        .blur(sendPlaceSizeUpdate);        

  $("#wizard_form input[type='checkbox']").change(sendCheckBoxUpdate);

  // Validate the zip code
  $('#place_zip').change(validateZipCode);

  // Place title change
  $('#place_title').change(function() {
    $('h1.title').html($(this).val());
  });  

  // Price per night
  $('#place_price_per_night').change(computeWeeklyMonthlyPay);

  // Place currency event
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

  // Place size event
  $('#place_place_size').blur(function() {
    if($(this).val() != "") {
      if($('#place_size_unit').val() == 'sqm') {
        $('#place_size_sqm').val($('#place_place_size').val());
        $('#place_size_sqm').attr('data-changed', 1);
        $('#place_size_sqm').trigger('blur');
        console.log($('#place_size_sqm').val());
      } else {
        $('#place_size_sqf').val($('#place_place_size').val());
        $('#place_size_sqf').attr('data-changed', 1);
        //$('#place_size_sqf').blur(sendFieldUpdate);
        $('#place_size_sqf').trigger('blur');
        console.log($('#place_size_sqf').val());
      }
    }
  });

  $('ul#wizard-selector li a').click(function(){
    $('#wizard_form').validationEngine('hideAll');
  });

  $("#days_minimum_stay").change(hideShowInputStay);
  $("#days_maximum_stay").change(hideShowInputStay);
  showHideInitialDefaultInput();

  $("a[rel=twipsy]").twipsy({
    live:true,
    animate: false,
    placement: 'below',
    html: true
  });

  $("a[rel=twipsy-link]").twipsy({
    live:true,
    animate: false,
    placement:'below',
    delayOut: 3000,
    html: true
  });


  $('#preview_button, #listing-status').click(validatePreview);


});
