
$(function () {
  // デフォルトの設定を変更
  $.extend( $.fn.dataTable.defaults, {
      language: {
          url: "http://cdn.datatables.net/plug-ins/9dcbecd42ad/i18n/Japanese.json"
      }
  });

  $("#example1").DataTable({
    "responsive": true,
    "autoWidth": false,
    "paging": false,
    "lengthChange": false,
    "searching": false,
    "destroy": true,
    "ordering": false,
    "info": false
  });

  $('tr').not('.modal-kakuninn-table tr').click(function(){
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
    window.location.href = '/buyers/claims/' + claim_id;
  });

  $('[data-toggle="tooltip"]').tooltip();
});
