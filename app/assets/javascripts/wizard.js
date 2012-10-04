//= require jquery.inlineedit

PhotoManager = {
  initialize: function(sortUrl, min_photo_count){
    this.min_photo_count = min_photo_count;
    this.initializePhotoSortable(sortUrl);
  },

  initializePhotoSortable: function(sortUrl){
    self = this;
    $('#photos_list').sortable({
        grid: [8,2],
        start: function(event, ui) {
          $(event.currentTarget).addClass('noclick');
        },
        stop: function(event, ui) {
          self.afterSort();

          $.ajax({
            type: 'PUT',
            url: sortUrl,
            data: $('#photos_list').sortable('serialize'),
            success: function() {
            }
          });
        }
    });

    self.afterSort();
    self.showLatestPhoto();

    $('#photos_list li').live('click', function(){
      if(!$(this).parent().hasClass('noclick')){
       PhotoManager.setPhoto($(this).find('img'));
      }
      $(this).parent().removeClass('noclick');
    });
  },
  afterSort: function(event, ui){
    $('#wizard_submit').attr('disabled', true);
    if($('#photos_list li').size() > 0) {
      $('.photos_wrapper').show();
    } else {
      $('.photos_wrapper').hide();
    }

    $('#photos_list li').removeClass("active");
    $('#photos_list li:first').addClass("active");

    $('#photos_list li').hover(function() {
      $(this).find(".photo_action").show();
    }, function() {
      $(this).find(".photo_action").hide();
    });
    if($('#photos_list li').size() >= this.min_photo_count) {
        $('#wizard_submit').attr('disabled', false);
    }
  },
  deletePhoto: function(photo){
    self = this;
    photo.fadeOut('slow', function(){
      photo.parent().remove();
      self.afterSort();
      self.showLatestPhoto();
    });
  },
  showLatestPhoto: function() {
    var photo = $('#photos_list li img').last();
    if(photo.size() > 0) {
      PhotoManager.setPhoto(photo);
    } else {
      $('.photo_wrapper').empty();
    }
  },
  insert: function(newList) {
    $('#photos_list').html(newList);
    this.afterSort();
    this.showLatestPhoto();
  },
  adjustScroll: function() {
    $('html').animate({scrollTop: $('.photo_wrapper').offset()['top'] - 60}, "slow");
  },
  setPhoto: function(photo) {
    $('.photo_wrapper').empty();

    var img_wrapper = $("<div class='active-photo well'></div>");

    var large_photo = photo.clone();
    large_photo.attr('src', large_photo.attr('data-large'));
    img_wrapper.append(large_photo);

    $('.photo_wrapper').append(img_wrapper);
    this.adjustScroll();
  }
}
