// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function showIndicator(elem) {
  elem.after("<span class='save-indicator'><img src='/images/loading.gif' alt='' /></span>");
}

function showSavedIndicator(elem) {
  elem.parent().find('.save-indicator').html("<span class='label success'>saved</span>");
  window.setTimeout(function() {
    hideIndicator(elem);
  }, 2000);
}

function showErrorIndicator(elem) {
  elem.after("<span class='save-indicator'><span class='label success'>error</span></span>")
  $('.save-indicator span').fadeOut(7000);
}

function validateElement(elem) {
  return $('#wizard_form').validationEngine('validateField', elem);
}

function hideIndicator(elem) {
  elem.parent().find('.save-indicator').detach();
}

$(function() {
  $('.generic-datepicker').datepicker({
    dateFormat: 'dd/mm/yy'
  });

  add_datepicker();

  $('input#hasGrayedDate.datepicker').datepicker({
    minDate: -0,
    maxDate: '3M',
    dateFormat: 'yy-mm-dd'
  });
  $('input#hasDate.datepicker').datepicker({
    dateFormat: 'yy-mm-dd'
  });

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
  });

  $(".preference-entry").change(function() {
    var me = $(this);
    var text_container = $(this).prev();

    showIndicator(me);
    $.ajax({
      type: 'PUT',
      url: '/users/change_preference.json',
      data: me.serialize(), 
      success: function(data) {
        showSavedIndicator(me);
        me.hide();
        text_container.children("span.text").html(me.children("option:selected").text());
        text_container.show();
      }
    });
  });

  $.waypoints.settings.scrollThrottle = 10;  
  $('.topbar').waypoint(function(event, direction) {
		$(this).toggleClass('sticky', direction === "down");
		event.stopPropagation();
	});
});

function add_datepicker() {
  // TODO: hack now. to make datepicker from-to live. focus only work "on"-focus (duh). So hasDatepicker class isn't assigned on load and from-to doesn't work.
  // I just re-bind it now, used in places/_step_5 and availabilities/_form

  //$('.from-to-picker').live('focus', function() {
  //  $(this).datepicker({

  $('.from-to-picker').datepicker('destroy').datepicker({
    dateFormat: 'dd/mm/yy',
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
