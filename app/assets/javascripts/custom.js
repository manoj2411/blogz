function pushAlert(message) {
  var message_box = '<div class="alert fade in alert-success "> <button class="close" data-dismiss="alert">×</button>' + message + '</div>'
  $(".alert").alert('close');
  $('#main-content').prepend(message_box);
}

$(document).on('page:load', function(){
  window['rangy'].initialized = false
})
