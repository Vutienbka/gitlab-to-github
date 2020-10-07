$(document).ready(function () {
  // TODO: FIXME change select2 css
  // $("#form-label-category").select2()
  // $("#form-label-category2").select2()
  // $("#form-label-category3").select2()
  let item_request_id = $('#item_request_id').val();

  $("#form-label-category").change(function () {
    $("#form-label-category3").empty();
    $("#form-label-category3").append("<option>未分類</option>");
  });

  $("#form-label-category").change(function () {
    let id = $(this).val();
    if (id == "") {
      let option = $('select[name="item_info[category1]"] option');
      id = parseInt(option[option.length - 1].value) + 2;
    }
    $.ajax({
      type: "GET",
      url: "/buyers/item_requests/" + item_request_id + "/item_info/sub_category/" + id,
      datatype: "json",
      headers: {
        "X-Transaction": "POST Example",
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
      },
      success: function (data, textStatus, jqXHR) { },
      error: function (jqXHR, textStatus, errorThrown) { },
    }).done(function (data) {
      var cities = data;
      $("#form-label-category2").empty();
      $("#form-label-category2").append("<option>未分類</option>");
      for (var i = 0; i < cities.length; i++) {
        $("#form-label-category2").append(
          '<option value="' +
          cities[i]["id"] +
          '">' +
          cities[i]["name"] +
          "</option>"
        );
      }
    });
  });

  $("#form-label-category2").change(function () {
    let id = $(this).val();
    if (id == "") {
      let option = $('select[name="item_info[category1]"] option');
      id = parseInt(option[option.length - 1].value) + 2;
    }
    $.ajax({
      type: "GET",
      url: "/buyers/item_requests/" + item_request_id + "/item_info/child_category/" + id,
      datatype: "json",
      headers: {
        "X-Transaction": "POST Example",
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
      },
      success: function (data, textStatus, jqXHR) { },
      error: function (jqXHR, textStatus, errorThrown) { },
    }).done(function (data) {
      var cities = data;
      $("#form-label-category3").empty();
      $("#form-label-category3").append("<option>未分類</option>");
      for (var i = 0; i < cities.length; i++) {
        $("#form-label-category3").append(
          '<option value="' +
          cities[i]["id"] +
          '">' +
          cities[i]["name"] +
          "</option>"
        );
      }
    });
  });
});
