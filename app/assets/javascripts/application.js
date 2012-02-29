// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// require less-1.1.3.min
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.ui.touch.punch.min
//= require jquery.tinycarousel.min
//= require jquery.cycle.all
//= require jquery.calendar
//= require jquery.waypoints.min
//= require jquery.charcounter
//= require jquery.validationEngine-en
//= require jquery.validationEngine
// require jquery.sausage
//= require jquery.bootstrap.confirm.popover
//= require jquery.bookmark
// require jquery.bookmark.ext
//= require modernizr
//= require preferences
//= require fullcalendar.min
//= require twitter/bootstrap
//= require_self
//= require_tree .
// %script{:src => 'https://maps.googleapis.com/maps/api/js?v=3&sensor=false', :type => 'text/javascript'}


// HOMEPAGE

function customerSupportDialog() {
 $("#fdbk_tab").click(); 
}
function showIndicator(elem) {
  elem.after("<span class='save-indicator'><img src='/images/loading.gif' alt='' /></span>");
}
function showRightIndicator(elem) {
  elem.after("<span class='save-indicator right'><img src='/images/loading.gif' alt='' /></span>");
}

function showSavedIndicator(elem) {
  elem.parent().find('.save-indicator').html("<span class='label success'>" + t('save') + "</span>");
  window.setTimeout(function() {
    hideIndicator(elem);
  }, 2000);
}

function showErrorIndicator(elem) {
  $('#place_zip').validationEngine('showPrompt', 'Invalid format of zipcode', 'load');
}

function validateElement(elem) {
  return $('#wizard_form').validationEngine('validateField', elem);
}

function hideIndicator(elem) {
  elem.parent().find('.save-indicator').detach();
}


  $('span#date-input-1').calendar({
    parentElement: 'div#date-input-1-container',
    dateFormat: '%d %B %Y'
  });

  $('span#date-input-2').calendar({
    parentElement: 'div#date-input-2-container',
    dateFormat: '%d %B %Y'
  });

  $(".preference").click(function() {
    $(this).hide().next().show();
    $(this).next().focus();
  });

  $(".preference-entry").change(function(event) {
    var me = $(this);
    var text_container = me.prev();

    if (me.val() != me.attr("data-current")) {
      showIndicator(me);
      $.ajax({
        type: 'PUT',
        url: '/users/change_preference.json',
        data: me.serialize(),
        success: function(data) {
          showSavedIndicator(me);

          me.attr("data-current", me.val());
          text_container.children("span.text").html(me.children("option:selected").text());

          me.hide();
          text_container.show();
          if($('#search_results').length > 0){
            window.location.reload();
          }
        }
      });
    } else {
      me.hide();
      text_container.show();
    }
  }).blur(function() {
    var me = $(this);
    var text_container = me.prev();
    me.hide();
    text_container.show();
  });

  $(".preference-entry > option").click(function() {
    $(this).parent().blur();
  });

function add_datepicker() {
  // TODO: hack now. to make datepicker from-to live. focus only work "on"-focus (duh). So hasDatepicker class isn't assigned on load and from-to doesn't work.
  // I just re-bind it now, used in places/_step_5 and availabilities/_form

  //$('.from-to-picker').live('focus', function() {
  //  $(this).datepicker({

  $('.from-to-picker').datepicker('destroy').datepicker({
    // dateFormat: 'dd/mm/yy',
    dateFormat: 'yy-mm-dd',
    minDate: +1,
    onSelect: function(selectedDate) {
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
  //});
}

$(document).ready(function() {
  $("#registerForm").submit(function(e) {
    var isChecked = $('#terms_and_conditions').is(':checked');
    if(!isChecked) {
      alert("Please check 'I accept the terms and conditions' to continue");
      e.preventDefault();
    }
  });

  $("a.tooltip, a[rel=tooltip]").tooltip({
      live:true,
      animate: false,
      placement: 'below',
      html: true
  });

  $("a.tooltip-link").tooltip({
    live:true,
    animate: false,
    placement:'below',
    delayOut: 3000,
    html: true
  });

  $('.dropdown-toggle').dropdown();
  
  $.waypoints.settings.scrollThrottle = 1;


  $('.topbar').waypoint(function(event, direction) {
    $(this).toggleClass('sticky', direction === "down");
    event.stopPropagation();
  });

  $('.wizard-aside, .wrap-searchbar, .search-aside').waypoint(function(event, direction) {
    $(this).toggleClass('sticky', direction === "down");
    event.stopPropagation();
	}, {offset: 52});  // NOTE: when you change this, goto heypal.less -> .sticky and change top attr

});

function disabled_question_button() {
  $("textarea").keyup(function() {
    var submit_button = $(this).parents('form').find('button.primary');

    if ($(this).val().length == 0) {
      submit_button.attr('disabled', 'disabled').addClass('disabled');
    } else {
      submit_button.removeAttr('disabled').removeClass('disabled');
    }
  }).keyup();
}

var Expandable = {
  initialize: function(selector){
	var container = $(selector);
	container.find('.expandable').each(function(){
	  var section = $(this);
	  section.find('.inner').hide();
	  section.addClass('collapsed');
	  section.click(function(){
		if(section.hasClass('collapsed')){
		  section.find('a').hide();
		  section.find('.inner').slideDown('slow');
		  section.removeClass('collapsed');
		  return false;
		} else {
		  section.find('a').show();
		  section.find('.inner').slideUp('slow', function(){
		    section.addClass('collapsed');	
		  });
		}
	  })
	})
  }
}