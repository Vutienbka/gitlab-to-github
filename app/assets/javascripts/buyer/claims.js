$(document).ready(function () {
  var availableTags = []


  $("#form-nolabel-claim-code").keyup(function () {
    availableTags = [];
    $.ajax({
      type: "POST",
      url: "/buyers/claims/list_item_info",
      data1: { "claim_item_code": $(this).val() },
      datatype: "json",
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
      },
      success: function (data, textStatus, jqXHR) { },
      error: function (jqXHR, textStatus, errorThrown) { },
    })
      .done(function (data1) {
        for (let i = 0; i < data1.length; i++) {
          availableTags.push(data1[i].SKU);
        }
      })
      .fail(function (data1) {
        console.log('Failure');
      });
    $('body').on('click', 'div.ui-menu-item-wrapper', function (e) {
      availableTags = [];
      console.log($(this).text());
      $.ajax({
        type: "POST",
        url: "/buyers/claims/auto_display_name",
        datatype: "json",
        data: { "claim_item_code": $(this).text() },
        headers: {
          "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
        },
        success: function (data, textStatus, jqXHR) { },
        error: function (jqXHR, textStatus, errorThrown) { },
      }).done(function (data) {
        console.log(data);
        $("#form-nolabel-claim-name").val(data.name);
        console.log(availableTags);
      })
        .fail(function (data) {
          console.log('Failure');
        })
    })


    $("#form-nolabel-claim-code").autocomplete({
      source: availableTags
    });
  });
}); 
