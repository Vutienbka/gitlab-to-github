$(document).ready(function() {
  count = 1
  $('.hidden-field').each(function(){
    $(this).val(count++)
  })
  $('#condition').on('cocoon:after-insert', function() {
    count = 1
    $('.hidden-field').each(function(){
      $(this).val(count++)
    })
  })
});
