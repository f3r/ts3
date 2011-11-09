// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  $('.generic-datepicker').datepicker({
    dateFormat: 'dd/mm/yy'
  });
  $('input#hasGrayedDate.datepicker').datepicker({
    minDate: -0,
    maxDate: '3M',
    dateFormat: 'yy-mm-dd'
  });
  $('input#hasDate.datepicker').datepicker({
    dateFormat: 'yy-mm-dd'
  });
});

$(function() {
  $('span#date-input-1').calendar({
    parentElement: 'div#date-input-1-container',
    dateFormat: '%d %B %Y'
  });
});

$(function() {
  $('span#date-input-2').calendar({
    parentElement: 'div#date-input-2-container',
    dateFormat: '%d %B %Y'
  });
});
