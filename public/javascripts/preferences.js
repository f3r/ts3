$(document).ready(function() {
	$('#toggle-preferences .dropdown-menu a').click(function(){
		var type = $(this).attr("data-type");
		var value = $(this).attr("data-value");
		var data = {};
		data["pref_" + type] = value;
		$.ajax({
	        type: 'PUT',
	        url: '/users/change_preference.json',
	        data: data,
	        success: function() {
				console.log(type);
				$('#toggle-preferences a[data-type=' + type + ']').parent('.dropdown-menu li').removeClass('active');
				$('#toggle-preferences a[data-type=' + type + '][data-value='+ value +']').parent('.dropdown-menu li').addClass('active');
	        }
      	});
      
	});
});