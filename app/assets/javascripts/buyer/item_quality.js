$(document).ready(function () {
    $('.js-quality').click(function(){
      id = $(this).attr('for')
      if ($('#' + id).is(':checked')) {
        $(this).parent().css('background-color', '#fce696');
        $('#' + id).val(0)
      } else {
        $(this).parent().css('background-color', '#fa1f6c');
        $('#' + id).val(1)
      }
    })
  })
  