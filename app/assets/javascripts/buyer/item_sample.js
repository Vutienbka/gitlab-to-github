$(document).ready(function() {
  for (var i = 1; i <= 3; i++) {
      selector = "input#category_type" + i + "[type='checkbox']"
      category_type = '#c-category_type'+ i

      if ($(category_type).val() == '' ) {
        $(category_type).val("0")
      }
      if ($(category_type).val() == "1") {
          ($(selector)).parent().css('background-color', '#fa1f6c');
      }
      if ($(category_type).val() == "0") {
          ($(selector)).parent().css('background-color', '#fce696');
      }
  }
  $('.js-sample').click(function() {
    id = $(this).attr('for')
    if ($('#c-' + id).val() == "1") {
        $(this).parent().css('background-color', '#fce696');
        $('#c-' + id).val("0")
    } else {
        $(this).parent().css('background-color', '#fa1f6c');
        $('#c-' + id).val("1")
    }
})
// js for category_type4  
  if ($('#c-category_type4').val() == '' ) {
    $('#c-category_type4').val("0")
  }
  if ($('#c-category_type4').val() == "1") {
      ($("input#category_type4[type='checkbox']")).parent().css('background-color', '#fa1f6c');
  }
  if ($('#c-category_type4').val() == "0") {
      ($("input#category_type4[type='checkbox']")).parent().css('background-color', '#b4c7e8');
  }
  $('.js-sample4').click(function() {
    id = $(this).attr('for')
    if ($('#c-' + id).val() == "1") {
        $(this).parent().css('background-color', '#b4c7e8');
        $('#c-' + id).val("0")
    } else {
        $(this).parent().css('background-color', '#fa1f6c');
        $('#c-' + id).val("1")
    }
})
})
