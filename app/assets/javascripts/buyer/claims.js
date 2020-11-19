$(document).ready(function (e) {
  $('input#item_code').val(localStorage.getItem('filter_item_code'));
  $('select option').each(function () {
    var data_name = $(this).attr('value');
    var value = sessionStorage.getItem(data_name)
    $(this).prop('selected', value)
  })

  $('input[type="text"]').each(function () {
    var name = $(this).attr('name');
    var value = sessionStorage.getItem(name);
    $(this).val(value);
  })

  var availableTags = []
  $("#form-nolabel-claim-code").keypress(function () {
    availableTags = [];
    $.ajax({
      type: "POST",
      url: "/buyers/claims/list_item_info",
      data: { "claim_item_code": $(this).val() },
      datatype: "json",
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
      },
    })
    .done(function (data) {
      for (let i = 0; i < data.length; i++) {
        availableTags.push(data[i].SKU);
      }
    })
    .fail(function (data) {
      console.log('Failure');
    });

    $('body').on('click', 'div.ui-menu-item-wrapper', function (e) {
      availableTags = [];
      $.ajax({
        type: "POST",
        url: "/buyers/claims/auto_display_name",
        datatype: "json",
        data: { "claim_item_code": $(this).text() },
        headers: {
          "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
        },
      })
      .done(function (data) {
        $("#form-nolabel-claim-name").val(data.name);
        $("#item_request_id").val(data.item_request_id);
        $("#form-nolabel-claim-code").attr('disabled', 'true');
        $("#form-nolabel-claim-name").attr('disabled', 'true');
      })
      .fail(function (data) {
        console.log('Failure');
      })
    })

    $("#form-nolabel-claim-code").autocomplete({
      source: availableTags
    });
  });

  $(document).on('click', '#former_claim_list', function () {
    sessionStorage.clear();
    var item_code = $('#form-nolabel-claim-code').val().trim();
    if (item_code === '') {
      item_code = 'blank';
    }
    var new_url = $('#former_claim_list').attr('href') + '?item_code=' + item_code;
    $('#former_claim_list').attr('href', new_url);
    localStorage.setItem("filter_item_code", item_code)
  })

  $('#claim_filter').on('click', function (e) {
    e.preventDefault(); // Now nothing will happen
    var item_code = $('h4.item-code').html();
    if (item_code != undefined) {
      item_code = item_code.replace('商品コード：', '').trim();
    }
    $('#claim-search').val('');
    $('#filter').submit();
  });

  $('#filter').on('submit', function () {
    sessionStorage.clear();
    $('select option').each(function () {
      if ($(this).is(':selected')) {
        var data_name = $(this).attr('value');
        var value = $(this).is(':selected');
        sessionStorage.setItem(data_name, value);
      }
    });

    $('input[type="text"]').each(function () {
      var name = $(this).attr('name');
      var value = $(this).val()
      sessionStorage.setItem(name, value);
    })

  });

  $(document).on('click', '.back_to_claim_table', function(){
    sessionStorage.clear();
  })

  $("tr").click(function() {
    var claim_id = $(this).find("td:first").html();
    window.location.href = '/buyers/claims/' + claim_id;
  });
});
