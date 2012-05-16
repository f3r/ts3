// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// TODO: Check if these are required
//    require less-1.1.3.min
//    require jquery.sausage
//    require jquery.bookmark.ext
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.ui.touch.punch.min
//= require jquery.tinycarousel.min
//= require jquery.cycle.all
//= require jquery.waypoints.min
//= require jquery.charcounter
//= require jquery.validationEngine-en
//= require jquery.validationEngine
//= require jquery.bootstrap.confirm.popover
//= require jquery.bookmark
//= require modernizr
//= require fullcalendar.min
//= require twitter/bootstrap
//= require_self
//= require_tree .

function customerSupportDialog() {
 $("#fdbk_tab").click(); 
}

function showIndicator(elem, html_attr) {
  if (arguments.length == 2) {
    elem.after("<span class='save-indicator' style=" + html_attr +"><img src='/assets/loading.gif' alt='' /></span>");
  } else {
    elem.after("<span class='save-indicator'><img src='/assets/loading.gif' alt='' /></span>");
  }
}

function showRightIndicator(elem) {
  elem.after("<span class='save-indicator right'><img src='/assets/loading.gif' alt='' /></span>");
}

function showSavedIndicator(elem) {
  elem.parent().find('.save-indicator').html("<span class='label success'>" + t('save') + "</span>");
  window.setTimeout(function() {
    hideIndicator(elem);
  }, 2000);
}

function showErrorIndicator(elem) {
  // $('#place_zip').validationEngine('showPrompt', 'Invalid format of zipcode', 'load');
  $(elem).validationEngine('showPrompt', 'Error', 'load');
}

function validateElement(elem) {
  if ($('#wizard_form').validationEngine('validateField', elem)) {
    elem.toggleClass("error");
    return true
  } else {
    elem.toggleClass("error");
    return false
  }
}

function hideIndicator(elem) {
  elem.parent().find('.save-indicator').detach();
}

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
}

$(document).ready(function() {
  $("#registerForm").submit(function(e) {
    var isChecked = $('#terms_and_conditions').is(':checked');
    if(!isChecked) {
      alert("Please check 'I accept the terms and conditions' to continue");
      e.preventDefault();
    }
  });

  $("a.tooltip, a[rel=tooltip], a[rel='tooltip nofollow'], button[rel=tooltip], a.tooltip-link").tooltip({
      animation: false,
      placement: 'top',
  }); 

  $('.dropdown-toggle').dropdown();
  
  $.waypoints.settings.scrollThrottle = 30;

  $('.navbar-wrapper').waypoint(function(event, direction) {
    $('.navbar').toggleClass('navbar-fixed-top', direction === "down");
    event.stopPropagation();
  });

  $('.wizard-aside-wrapper').waypoint(function(event, direction) {
    $(this).children().toggleClass('sticky', direction === "down");
    event.stopPropagation();
	}, {offset: 62});  // NOTE: when you change this, goto application.css.less -> .sticky and change top attr

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