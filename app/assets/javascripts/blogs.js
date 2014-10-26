$(document).on('change', 'input[name="blog[status]"]', function(){
  $(this).closest('form.blog-status-form').submit();
})
