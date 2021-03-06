$(document).ready(function () {
  // Get all checked inputs
  if ($('.choose:checkbox:checked').length > 0) {
    $("#submit-form").removeAttr("disabled");
  }

  for (var i = 1; i <= 16; i++) {
    selector = "input#quality" + i + "[type='checkbox']";
    quality = "#q-quality" + i;
    info = "#q-info" + i;
  if ($(quality).val() == null) {
    $(quality).val("0");
    $(info).val('');
  }
  }
  $(".js-quality").click(function () {
    id = $(this).attr("for");
    info = "#q-info" + id.replace('quality','');
  if ($("#q-" + id).val() == "1") {
    $("#q-" + id).val("0");
    $(info).val('');

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
    $(info).val($(this).html());
    $("#submit-form").removeAttr("disabled");
  }
  });
});
