var PlaceComments = {

  initialize: function(){

    $("#open-ask-btn").click(function() {
      $(this).hide();
      $("#ask-form").show();
    });

    $("#ask-cancel").click(function() {
      $("#ask-form").hide();
      $("#open-ask-btn").show();
      return false;
    });

    $("#ask-btn").click(function() {
      showIndicator($(this));
    });

    // Click on Reply will show reply_form
    $(".open-respond-form").live('click', function() {
      $(this).next().show();
      $(this).hide();
    });

    // Click on Cancel in reply_form will hide the form and show reply button
    $(".respond-cancel").live('click', function() {
      $('.open-respond-form').show();
      $('#respond-form-div').hide();
      return false;
    });

    // Click on submit reply will show indicator
    $(".respond-btn").live('click', function() {
      showIndicator($(this), 'margin-left:17px');
    });

    $(".del").live('click', function() {
      //showIndicator($(this));
    });

    
    // Show the delete link on mouseover
    $(".answer").hover(
      function() { $("#del-reply").show();  },
      function() { $("#del-reply").hide();  }
    );
    
    disabled_question_button();
  },
  
  addComment: function(html){
    $('.item-questions').append(html);
    $('#respond-form-div').hide();
    hideIndicator($('#ask-btn'));
    $('#open-ask-btn').show();
    $('#comment_comment').val('');
    disabled_question_button();
  }
}