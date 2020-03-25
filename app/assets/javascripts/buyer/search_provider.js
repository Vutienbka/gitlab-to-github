$(document).ready(function() {
  $("#myBtn").click(function(){
    $("#myModal").modal();
  });

  $("#list_email").hide();

  $("#search").on("keyup", function() {
    var data = $(this).val();
    console.log(data);
    $.ajax({
        url: '/buyers/search_provider',
        type: 'GET',
        dataType: 'script',
        data: {
          "search": data
        },
        success: function(data){
          $( ".email-user" ).click(function() {
            $("#list_email").hide()
            let id = $(this).html()
            $('#search').val(id);
          });
        }
    });

    if (data == "") {
      $("#list_email").hide()
    } else {
      $("#list_email").show()
    }
  });
});