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
		}
	});
});
