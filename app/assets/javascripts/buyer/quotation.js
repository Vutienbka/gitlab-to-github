$(document).ready(function(){
  $("#myBtn").attr('disabled', true);
  $("#confirm_file").click(function(){
    $("#myBtn").attr('disabled', false);
  })
});
