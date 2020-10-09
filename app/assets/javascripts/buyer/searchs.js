$(document).ready(function () {
  var availableTags = []

  $("#newji-serch").keyup(function () {
    availableTags = []
    $.ajax({
      type: "POST",
      url: "/buyers/searchs/list_auto",
      data: {
        'q': $(this).val()
      },
      datatype: "json",
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
      },
      success: function (data, textStatus, jqXHR) { },
      error: function (jqXHR, textStatus, errorThrown) { },
    }).done(function (data) {
      console.log(data);
      for (let i = 0; i < data.length; i++) {
        availableTags.push(data[i].name);
      }
      console.log(availableTags);
    })
      .fail(function (data) {
        console.log('thatbai');
      })

    $("#newji-serch").autocomplete({
      source: availableTags
    });
  });
});
