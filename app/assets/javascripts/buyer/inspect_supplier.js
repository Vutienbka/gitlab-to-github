function set_color(button) {
  $(button).click(function(){
    $(".btn-check").css('background-color', '#ffd966');
    $("#label_" + $(this).attr('id')).css('background-color', '#fa1f6c');
    $("#button_apply").attr('disabled', false);
  });
}

$(document).ready(function() {
  $("#button_apply").attr('disabled', true);

  set_color("#ordinary");
  set_color("#limited");
  set_color("#super");

  $(window).submit('beforeunload', function(e){
    if ($('#inspection_request_inspect_company_name').val() === undefined || $('#inspection_request_inspect_company_name').val() === '' ||
        $('#inspection_request_inspect_address').val() === undefined || $('#inspection_request_inspect_address').val() === '' ||
        $('#inspection_request_inspect_tel').val() === undefined || $('#inspection_request_inspect_tel').val() === '' ||
        !$('#ordinary').is(':checked') && !$('#limited').is(':checked') && !$('#super').is(':checked')
      ) {
    }
    else {
      $('body').addClass("loading");
    }
  });
})
