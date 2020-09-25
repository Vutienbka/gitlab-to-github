$(document).ready(function() {
  $("#list_email").hide();
  $("#newji-serch").on("keyup", function() {
    var data = $(this).val();
    $.ajax({
        url: '/buyers/search_provider',
        type: 'GET',
        dataType: 'script',
        data: {
          "search": data
        },
        success: function(data){
        }
    });

    if (data == "") {
      $("#list_email").hide()
    } else {
      $("#list_email").show()
    }
  });

  $(document).on('click','.pass_data_to_modal', function(){
    let base_url = window.location.origin
    let id = $(this).attr('id').replace('pass_data_to_modal_','')
    $('#create_item_request').attr('href', base_url + '/buyers/item_requests?supplier_id=' + id)
    $('#create_item_request_private_contract').attr('href', base_url + '/buyers/item_requests/private_contract?supplier_id=' + id)
  });
});
