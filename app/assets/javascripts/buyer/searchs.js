$(document).ready(function () {
  var item_code_search_submit = $('#claim_item_code').val(localStorage.getItem('item_code_from_url'));
  var availableTags = []
  $('#result').hide();
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
      for (let i = 0; i < data.length; i++) {
        availableTags.push(data[i].name);
      }
    })
      .fail(function (data) {
        console.log('失敗しました');
      })

    $("#newji-serch").autocomplete({
      source: availableTags
    });
  });

  $("#claim-search").keyup(function () {
    $("#result").empty();
    localStorage.clear();
    let data = $(this).val();
    let item_code = $('.item-code').text().replace('商品コード：', '');
    $('#claim_item_code').val(item_code);
    localStorage.setItem("item_code_from_url", item_code);
    $.ajax({
      type: 'GET',
      url: '/buyers/searchs/claim_suggest_search',
      data: {
        'q': data,
        'item_code': item_code
      },
      dataType: 'json',
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
      },
      success: function (data, textStatus, jqXHR) { },
      error: function (jqXHR, textStatus, errorThrown) { },
    }).done(function (data) {
      if (data !== null) {
        $("#result").empty();
        for (let i = 0; i <= data.length - 1; i++) {
          $("#result").append(
            '<div class="claims">' +
              '<div class="claim_detail" id="claim_detail_' + data[i][0] + '">' +
                '<div class="claim_info" data-claim-lot-number="lot_number_' + data[i][1] + '" data-claim-classify="claim_classify_' + data[i][2] + '">' + 'ロットナンバー: ' + data[i][1] + ' | ' +
                  'アイテムコード: ' + data[i][2] + ' | ' +  'アイテム名: ' + data[i][3] + ' | ' +'サプライヤー名: ' + data[i][4] +
                '</div>' +
              '</div>' +
            '</div>')
        }
      }
      if (data === null) {
        $('#result').hide();
      } else {
        if (data.length <= 0) {
          $('#result').hide();
        } else {
          $('#result').show();
        }
      }
    })
      .fail(function (data) {
        console.log('失敗しました');
      })

    if (data == '') {
      $('#result').hide();
    } else {
      $('#result').show();
    }

  });

  $(document).on('click', '.claim_detail', function () {
    $('#result').hide();
    let claim_id = $(this).attr('id').replace('claim_detail_', '');
    $.ajax({
      type: 'GET',
      url: '/buyers/claims/search_with_ajax',
      data: {
        'id': claim_id
      },
      dataType: 'json',
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
      },
      success: function (data, textStatus, jqXHR) { },
      error: function (jqXHR, textStatus, errorThrown) { },
    }).done(function (data) {
      $('#example1').replaceWith(data.html)
    })
      .fail(function (data) {
        console.log('失敗しました');
      })
  })

  $('#form_claims_search').submit(function(e){
    let item_code_from_url = getUrlParameter('item_code');
    localStorage.setItem("item_code_from_url", item_code_from_url);
  })

  var getUrlParameter = function getUrlParameter(sParam) {
    let sPageURL = window.location.search.substring(1),
      sURLVariables = sPageURL.split('&'),
      sParameterName,
      i;

    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split('=');

      if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
      }
    }
  };
});
