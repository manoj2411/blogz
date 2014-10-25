$(document).on('change', 'input[name="comment[status]"]', function(){
  $(this).closest('form.edit_comment').submit();
})
