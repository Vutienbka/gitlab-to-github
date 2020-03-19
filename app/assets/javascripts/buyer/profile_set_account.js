function set_color(button) {
  $(button).click(function(){
    $(".submit-account").css('background-color', '#ffd966');
    $("#label_" + $(this).attr('id')).css('background-color', '#fa1f6c');
  });
}

$(document).ready(function() {
  set_color("#buyer_account");
  set_color("#supplier_account");
  set_color("#buyer_supplier_account");
})
