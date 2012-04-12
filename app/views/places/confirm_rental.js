$('.alert').remove();
<% if @response == "success" %>
$('button#confirm_rental').remove();
$('.conversation').before('<div class="alert alert-success" data-alert="alert"><a href="#" class="close" data-dismiss="alert">×</a><%= t(:confirm_success) %></div>');
<% else %>
$('.conversation').before('<div class="alert alert-error" data-alert="alert"><a href="#" class="close" data-dismiss="alert">×</a><%= t(:confirm_error) %></div>');
<% end %>