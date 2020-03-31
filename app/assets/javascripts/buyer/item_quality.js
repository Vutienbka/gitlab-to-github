$(document).ready(function () {
  for (var i = 1; i <= 16; i++) {
    selector = "input#quality"+i+"[type='checkbox']"
    if($(selector).val() == 1) {
      ($(selector)).parent().css('background-color', '#fa1f6c');
    }
    if($(selector).val() == 0) {
      ($(selector)).parent().css('background-color', '#fce696');
    }
  }
  $('.js-quality').click(function(){
    id = $(this).attr('for')
    if ($('#' + id).val() == 1 ) {
      $(this).parent().css('background-color', '#fce696');
      $('#' + id).val(0)
    } else {
      $(this).parent().css('background-color', '#fa1f6c');
      $('#' + id).val(1)
    }
  })
})
