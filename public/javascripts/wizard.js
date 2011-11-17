/*
var place_id = $('#place_id').val();
var token = $('#token').val();
var access_token = $('#accessToken').val();
*/

var zipCodeVal = true;

/*********************
* Panels
**********************/

var switchPanel = function() {
  _this = $(this);

  $('.wizard-wrapper .panel').hide();
  $(_this.attr('href')).fadeIn('fast');

  _this.parent().parent().find('a').removeClass('active');
  _this.addClass('active');

  validatePanels();
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


/*********************
* Initialize here 
**********************/
$(document).ready(function() {

  // Wizard Selector
  $('ul#wizard-selector li a').die().bind('click', switchPanel);

  // Validation engine
  $('#wizard_form').validationEngine();

  // Character count
  $('#place_title').charCounter(32, {container: "<em></em>",classname: "counter", format: "(%1)"});
  $('#place_description').charCounter(20, {container: "<em></em>",classname: "counter", format: "(%1)"});

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
  $('#place_price_per_night').change(function() {
    var access_token = $('#accessToken').val();
    var per_week = $(this).val() * 7;
    var per_month = $(this).val() * 30;
    var total_per_week = per_week - (per_week * .95);
    var total_per_month = per_month - (per_month * .95);
    var currency_sign = $('.currency-sign-id').text();
    total_per_week = Math.round(total_per_week);

    if(per_week != 0){
      $('#estimated_amount_weekly').html("Based on your daily price, we recommend " + currency_sign + total_per_week);
    }
    if(per_month != 0){
      $('#estimated_amount_monthly').html("Based on your daily price, we recommend " + currency_sign + total_per_month);
    }
  });

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
    $('.formError').fadeOut(150, function() {
      $('.formError').remove();
    });
  });

});
