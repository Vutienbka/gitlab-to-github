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

  $(document).on('click', '.ui-menu-item', function () {
    var item_info_id = $(this).children('div').attr('id').replace('ui-id-', '');
    $('#item_info_id').val(item_info_id);
    var url = $('#new_claims').attr('action')
    url = url + '?item_info_id=' + item_info_id;
    $('#new_claims').attr('action', url)
    console.log(url);
  })

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

}); 
