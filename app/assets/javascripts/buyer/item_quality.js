$(document).ready(function () {
  // Get all checked inputs
  if ($('.choose:checkbox:checked').length > 0) {
    $("#submit-form").removeAttr("disabled");
  }

  for (var i = 1; i <= 16; i++) {
    selector = "input#quality" + i + "[type='checkbox']";
    quality = "#q-quality" + i;
    if ($(quality).val() == null) {
      $(quality).val("0");
    }
  }
  $(".js-quality").click(function () {
    id = $(this).attr("for");
    if ($("#q-" + id).val() == "1") {
      $("#q-" + id).val("0");
      let check = true;
      for (var i = 1; i <= 16; i++) {
        selector = "input#quality" + i + "[type='checkbox']";
        quality = "#q-quality" + i;
        if ($(quality).val() == 1) {
          check = false;
        }
      }
      if (check) {
        $("#submit-form").attr("disabled", "disabled");
      }
    } else {
      $("#q-" + id).val("1");
      $("#submit-form").removeAttr("disabled");
    }
  });
});
