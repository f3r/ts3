var place_id = $('#place_id').val();
var token = $('#token').val();
var access_token = $('#accessToken').val();

var zipCodeVal = true;

/*********************
* Panels
**********************/

var switchPanel = function() {

    // Remove form errors
  if($('.formError').size() > 0) {
    alert("Please fix the error on the form first before we can proceed.");
    return false;
  }

  _this = $(this);

  $('.wizard-wrapper .panel').hide();
  $(_this.attr('href')).fadeIn('fast');

  $('.section_title').html(_this.attr('title'));

  _this.parent().parent().find('a').removeClass('active');
  _this.addClass('active');

  validatePanels(_this);
  return false;
};

var switchToPanel = function(target) {
  $('ul#wizard-selector li a[href="' + target + '"]').click();
}

var validatePanels = function(target) {
  // Title, Apartment type, Number of guests, Size, Description (>20 chars) and Address
  // At least one photo
  // daily price, currency and cancellation policy
  // Amenities. checked by default
  var wizard_aside = $('.wizard-aside');
  
  // General Validation
  if($('#place_title').val() && $('#place_max_guests').val() && $('#place_size').val() && $('#place_description').val() && $('#place_description').val().length >= 20) {
    wizard_aside.find('li#general .indicator img').attr('src', '/images/check.png');
  } else {
    wizard_aside.find('li#general .indicator img').attr('src', '/images/check-disabled.png');
  }

  if($('#photos_list li').size() > 0) {
    wizard_aside.find('li#photos .indicator img').attr('src', '/images/check.png');
  } else {
    wizard_aside.find('li#photos .indicator img').attr('src', '/images/check-disabled.png');
  }

  if($('#place_price_per_night').val() && $('#place_currency').val() && $('#place_cancellation_policy').val()) {
    wizard_aside.find('li#price .indicator img').attr('src', '/images/check.png');
  } else {
    wizard_aside.find('li#price .indicator img').attr('src', '/images/check-disabled.png');
  }

  if(target && target.attr('href') == '#3') {
    wizard_aside.find('li#amenities .indicator img').attr('src', '/images/check.png');
  }

  if(target && target.attr('href') == '#4') {
    wizard_aside.find('li#calendar .indicator img').attr('src', '/images/check.png');
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
};  

var trackChange = function() {
  $(this).attr('data-changed', "1");
};

var validateZipCode = function() {
  var country_id = $('#place_city_id').val();
  var zip = $(this).val();
  if(zip.match(/\d{6}/) && (country_id == '1' || country_id == 'IN' || country_id == 'SG' || country_id == 'VN' || country_id == 'CN' )) {
    zipCodeVal = true;
  } else if(zip.match(/\d{5}/) && (country_id == 'ID' || country_id == 'MY' || country_id == 'TH' || country_id == '4065')) {
    zipCodeVal = true;
  } else if(zip.match(/\d{4}/) && (country_id == 'AU' || country_id == 'PH')) {
    zipCodeVal = true;
  } else if(zip.match(/\d{5}([ \-]\d{4})?/) && country_id == 'US') {
    zipCodeVal = true;
  } else if(country_id == '13984' && zip.match(/\d/)){
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
  } else {
    placeInput.hide();

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
    $('#estimated_amount_weekly').html("Based on your daily price, we recommend " + currency_sign + total_per_week);
    $('#estimated_amount_monthly').html("Based on your daily price, we recommend " + currency_sign + total_per_month);
  }
};


function showHideInitialDefultInput() {
  //check the value of minimum and maximum days
  var place_min = $('#place_minimum_stay_days').val();
  if(place_min == '' || place_min == undefined) {
    $('#place_minimum_stay_days').hide();
    $('select#days_minimum_stay').val('1');
  } else {
    $('#place_minimum_stay_days').show();
    $('select#days_minimum_stay').val('0');
  };

  var place_min = $('#place_maximum_stay_days').val();
  if(place_min == '' || place_min == undefined) {
    $('#place_maximum_stay_days').hide();
    $('select#days_maximum_stay').val('1');
  } else {
    $('#place_maximum_stay_days').show();
    $('select#days_maximum_stay').val('0');
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
    live:true
  }).css({'border': '1px solid', 'border-radius' : '5px', 'margin-left': '10px', 'padding' : '2px'});
});
