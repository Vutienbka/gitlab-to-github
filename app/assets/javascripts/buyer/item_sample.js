$(document).ready(function() {
  for (var i = 1; i <= 3; i++) {
      selector = "input#category_type" + i + "[type='checkbox']"
      category_type = '#c-category_type'+ i
      if ($(category_type).val() == '' ) {
        $(category_type).val("0")
      }
      if ($(category_type).val() == "1") {
          ($(selector)).parent().css('background-color', '#fa1f6c');
          ($(selector)).parent().children(":first").children(":first").css('color', 'white');
      }
      if ($(category_type).val() == "0") {
          ($(selector)).parent().css('background-color', '#fce696');
          ($(selector)).parent().children(":first").children(":first").css('color', '#000');
      }
  }
  $('.js-sample').click(function() {
    id = $(this).attr('for')
    if ($('#c-' + id).val() == "1") {
        $(this).parent().css('background-color', '#fce696');
        $(this).children(":first").css('color', '#000');
        $('#c-' + id).val("0")
    } else {
        $(this).parent().css('background-color', '#fa1f6c');
        $(this).children(":first").css('color', 'white');
        $('#c-' + id).val("1")
    }
})
// js for category_type4  
  if ($('#c-category_type4').val() == '' ) {
    $('#c-category_type4').val("0")
  }
  if ($('#c-category_type4').val() == "1") {
      ($("input#category_type4[type='checkbox']")).parent().css('background-color', '#fa1f6c');
      ($("input#category_type4[type='checkbox']")).parent().children(":first").children(":first").css('color', 'white');
  }
  if ($('#c-category_type4').val() == "0") {
      ($("input#category_type4[type='checkbox']")).parent().css('background-color', '#b4c7e8');
      ($("input#category_type4[type='checkbox']")).parent().children(":first").children(":first").css('color', '#000');
  }
  $('.js-sample4').click(function() {
    id = $(this).attr('for')
    if ($('#c-' + id).val() == "1") {
        $(this).parent().css('background-color', '#b4c7e8');
        $(this).children(":first").css('color', '#000');
        $('#c-' + id).val("0")
    } else {
        $(this).parent().css('background-color', '#fa1f6c');
        $(this).children(":first").css('color', 'white');
        $('#c-' + id).val("1")
    }
})
})
