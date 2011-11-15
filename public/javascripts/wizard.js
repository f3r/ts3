
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


}

$(function() {

  /*******************
  * Wizard Sidebar
  ********************/

  $('.wizard-wrapper .panel').css("display", "none");

  $('ul#wizard-selector li a').die().bind('click', switchPanel);


});
