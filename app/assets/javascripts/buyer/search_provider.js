$(document).ready(function() {
  $("#list_email").hide();
  $("#myBtn").attr('disabled', true);

  $("#search").on("keyup", function() {
    var data = $(this).val();
    $.ajax({
        url: '/buyers/search_provider',
        type: 'GET',
        dataType: 'script',
        data: {
          "search": data
        },
        success: function(data){
          $( ".email-user" ).click(function() {
            $("#list_email").hide();
            $("#myBtn").attr('disabled', false);
            let name = $(this).html();
            $('#search').val(name);
            let id = $(this).attr('id').replace('email_user_','');
            let url = window.location.origin;
            $("#link_to_href").attr("href", url+ "/buyers/requests?supplier_id=" + id);
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
