$(document).ready(function() {
	$('#toggle-preferences .dropdown-menu a').click(function(){
		// console.log($(this).attr("data-type"));
		// console.log($(this).attr("data-value"));
		
		// data = { $(this).attr("data-type").val() : $(this).attr("data-value") }
		type = $(this).attr("data-type");
		value = $(this).attr("data-value");
		var data = { };
		data["pref_" + type] = value;
		$.ajax({
		        type: 'PUT',
		        url: '/users/change_preference.json',
		        data: data,
		        success: function() {
					$('li[data-type=' + type + ']').removeClass('active');
		          // showSavedIndicator(elem);
		          // elem.attr('data-changed', '0');
		        }
      	});
      
	});
});