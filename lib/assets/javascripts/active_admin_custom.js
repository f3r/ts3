//= require redactor/redactor
//= require pluploader

$(document).ready(function() {
	 var csrf_token = $('meta[name=csrf-token]').attr('content');
	  var csrf_param = $('meta[name=csrf-param]').attr('content');
	  var params;
	  if (csrf_param !== undefined && csrf_token !== undefined) {
	    params = csrf_param + "=" + encodeURIComponent(csrf_token);
	}
	$('.tinymce').redactor({
		autoresize: false,
		imageUpload: '/admin/cmspages/image_upload?' + params,
		imageGetJson: '/admin/cmspages/images?' + params,
		wym: true,
		keyupCallback: function(obj, e) {
			Cmspage.isDirty = true;
		},
		buttons: ['html', '|', 'formatting', '|', 'bold', 'italic', '|',
		'unorderedlist', 'orderedlist', 'outdent', 'indent', '|',
		'image', 'video', 'file', 'table', 'link', '|',
		'fontcolor', '|',
		'alignleft', 'aligncenter', 'alignright', 'justify', '|',
		'horizontalrule']
	});


	$('#new_user #user_send_invitation').on('click', function(){
		if($(this).is(':checked')){
			$('#user_invitation_text').removeAttr('disabled');
		} else {
			$('#user_invitation_text').attr("disabled", "disabled");
		}
	}).triggerHandler('click');


    $("#custom_field_type_cd").on('change',function () {

        //First we hide all of them
        $("#custom_field_more_info_label_input").hide();
        $("#custom_field_date_format_input").hide();
        $("#custom_field_values_input").show();

        switch($(this).val()) {
            case "5":
                $("#custom_field_more_info_label_input").show();
                //Break is left intentionally
            case "4":
                $("#custom_field_values_input").hide();
                break;
            case "6":
                $("#custom_field_date_format_input").show();
                $("#custom_field_values_input").hide();
                break;
        }

    }).triggerHandler('change');
});
