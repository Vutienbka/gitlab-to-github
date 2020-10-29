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
  });

  $(document).on('click', '.email-user', function(){
    var current_user_id = $(this).attr('id').replace('email_user_','');
    $('#newji-serch').val($(this).children('div.name-supplier').html().trim());
    $('#search_supplier_with_id').val(current_user_id);
    $('#newji-serch').focus()
    $("#list_email").hide()
  })

});
