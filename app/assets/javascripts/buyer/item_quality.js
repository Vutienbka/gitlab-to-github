$(document).ready(function() {
  for (var i = 1; i <= 16; i++) {
    selector = "input#quality" + i + "[type='checkbox']"
    quality = '#q-quality' + i
    if ($(quality).val() == null) {
      $(quality).val("0")
    }
  }
  $('.js-quality').click(function() {
    id = $(this).attr('for')
    if ($('#q-' + id).val() == "1") {
        $('#q-' + id).val("0")
    } else {
        $('#q-' + id).val("1")
    }
  })
})
