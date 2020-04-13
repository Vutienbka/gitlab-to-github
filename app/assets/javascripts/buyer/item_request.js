$(document).ready(function() {
  $("#search").on("keyup", function() {
    var data = $(this).val();
    $.ajax({
        url: '/buyers/item_requests',
        type: 'GET',
        dataType: 'script',
        data: {
          "search": data
        },
    });

    if (data == "") {
      $(".page-item").show()
    } else {
      $(".page-item").hide()
    }
  });
});
