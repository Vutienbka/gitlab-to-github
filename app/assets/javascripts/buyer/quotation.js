$(document).ready(function(){
  $("#myBtn").attr('disabled', true);
  $("#confirm_file").click(function(){
    $("#myBtn").attr('disabled', false);
  })
  $("#modal_submit_button").click(function(){
    $(".modal-content").hide();
  })
});
$(window).on('beforeunload', function(){
  $('body').addClass("loading");
});