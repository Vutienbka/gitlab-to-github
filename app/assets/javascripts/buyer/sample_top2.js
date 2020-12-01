$(document).ready(function(){
  // デフォルトの設定を変更
  

  $('tr').not('.modal-kakuninn-table tr').click(function(){
    //$(this).attr('data-target','#modal-default');
    if($(this).hasClass('select--click')){
      return;
    } else {
      $(this).addClass("select--click");
    }
  });

  // セルをマウスオーバー
  $("td").hover(function(){
    // 親要素（tr要素）にtargetクラスを追加
    $(this).parent().addClass("target").addClass('select');
    //クリックしたときの浮き出を解除
    $('tr').removeClass("select--click");

    // 親要素から見て、自分が何番目の子要素なのか調べる
    var myIndex = $(this).index();

    // myIndexに1プラス
    myIndex ++;

    // 各行の「myIndex番目の子要素」にtargetクラスを追加する
    $("td:nth-child(" + myIndex + ")").addClass("target");
  }, function(){
    // マウスアウト時にtargetクラスを削除
    $(".target").removeClass("target").removeClass("select");

  });

  /*ページ遷移*/
  $("tr").click(function() {
    var claim_id = $(this).find("td:first").html();
    console.log(claim_id)
    window.location.href = '/suppliers/samples/' + claim_id;
  });

});

$(document).ready(function() {
  $.datepicker._gotoToday = function(id) {
    var target = $(id);
    var inst = this._getInst(target[0]);
    var date = new Date();
    this._setDate(inst,date);
    this._hideDatepicker();
  }

  $('#select-period-from').datepicker({
    autoclose: false,
    showButtonPanel: true,
    changeYear: true,  // 年選択をプルダウン化
  });

  // IOSか判定
  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {

    // 現在フォーカスが当たっているinput, textarea以外にreadonlyを設定
    $('#select-period-from').on('focus', function() {
      $('input, textarea').not(this).attr("readonly", "readonly");
    });

    // フォーカスが外れるときにreadonlyを外す
    $('#select-period-from').on('blur', function() {
      $('input, textarea').not(this).removeAttr("readonly");
    });
  }

  $('#select-period-to').datepicker({
    autoclose: false,
    showButtonPanel: true,
    changeYear: true,  // 年選択をプルダウン化
  });

  // IOSか判定
  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {

    // 現在フォーカスが当たっているinput, textarea以外にreadonlyを設定
    $('#select-period-to').on('focus', function() {
      $('input, textarea').not(this).attr("readonly", "readonly");
    });

    // フォーカスが外れるときにreadonlyを外す
    $('#select-period-to').on('blur', function() {
      $('input, textarea').not(this).removeAttr("readonly");
    });
  }
});