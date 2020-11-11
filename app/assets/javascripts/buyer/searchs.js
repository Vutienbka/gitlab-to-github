$(document).ready(function () {
  var item_code_search_submit = $('#claim_item_code').val(localStorage.getItem('item_code_from_url'));
  var search_input = localStorage.getItem('search_claim_with_submit');
  $('#sample_result').hide();
  if (search_input !=''){
    $('#claim-search').val(search_input);
  }
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
    localStorage.setItem("filter_item_code", item_code)
    localStorage.setItem('search_claim_with_submit', $(this).val())  
    suggest_search($("#claim-search"), $("#result"), '/buyers/searchs/claim_suggest_search', 'claim', data)
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

  $(document).on('click', '#search_claim_with_submit', function(e){
    let search_input = $('#claim-search').val();
    if (search_input !=''){
      localStorage.setItem('search_claim_with_submit', search_input)
    }
  })

  $("#sample-search").keyup(function () {
    $("#sample_result").empty();
    localStorage.clear();
    let data = $(this).val();
    suggest_search($("#sample-search"), $("#sample_result"), '/buyers/searchs/sample_suggest_search', 'sample', data)
  });

  $(document).on('click', '.sample_detail', function () {
    $('#sample_result').hide();
    let sample_id = $(this).attr('id').replace('sample_detail_', '');
    $.ajax({
      type: 'GET',
      url: '/buyers/samples/search_with_ajax',
      data: {
        'id': sample_id
      },
      dataType: 'json',
      headers: {
        "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
      },
      success: function (data, textStatus, jqXHR) { },
      error: function (jqXHR, textStatus, errorThrown) { },
    }).done(function (data) {
      console.log(data)
      $('#example2').replaceWith(data.html)
    })
      .fail(function (data) {
        console.log('失敗しました');
      })
  })

  function suggest_search(text_element, result_element, url, append_type, query_string){
      $.ajax({
        type: 'GET',
        url: url,
        data: {
          'q': query_string,
        },
        dataType: 'json',
        headers: {
          "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
        },
        success: function (data, textStatus, jqXHR) { },
        error: function (jqXHR, textStatus, errorThrown) { },
      }).done(function (data) {
        if (data !== null) {
          result_element.empty();
          if (data.length <= 0) {
            result_element.hide();
          } else {
            result_element.show();
          }
          if(append_type == 'sample'){
          append_sample(result_element, data)
          } else {
            append_claim(result_element, data)
          }
        }else{
          result_element.hide();
        }
      })
        .fail(function (data) {
          console.log('失敗しました');
        })
  
      if (query_string == '') {
        result_element.hide();
      } else {
        result_element.show();
      }
  }

  function append_claim(result_element, data){
    for (let i = 0; i <= data.length - 1; i++) {
      result_element.append(
        '<div class="claims">' +
          '<div class="claim_detail" id="claim_detail_' + data[i][0] + '">' +
            '<div class="claim_info" data-claim-lot-number="lot_number_' + data[i][1] + '" data-claim-classify="claim_classify_' + data[i][2] + '">' + 'ロットナンバー: ' + data[i][1] + ' | ' +
              'アイテムコード: ' + data[i][2] + ' | ' +  'アイテム名: ' + data[i][3] + ' | ' +'サプライヤー名: ' + data[i][4] +
            '</div>' +
          '</div>' +
        '</div>')
    }
  }

  function append_sample(result_element, data){
    for (let i = 0; i <= data.length - 1; i++) {
      result_element.append(
        '<div class="samples">' +
          '<div class="sample_detail" id="sample_detail_' + data[i][0] + '">' +
            '<div class="sample_info" data-sample-title="title_' + data[i][1] + '" data-sample-classify="code_' + data[i][2] + '">' + 'サンプルタイトル: ' + data[i][1] + ' | ' + 'サンプルコード: ' + data[i][2] + ' | ' +
              'アイテムコード: ' + data[i][3] + ' | ' +  'アイテム名: ' + data[i][4] + ' | ' +'サプライヤー名: ' + data[i][5] +
            '</div>' +
          '</div>' +
        '</div>')
    }
  }

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
