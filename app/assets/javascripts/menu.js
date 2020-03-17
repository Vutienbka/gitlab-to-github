$(document).ready(function() {
    $('#hiden-bar').click(function() {
      $('.sidebar').width("350px");
      $(this).hide()

    });
    
    $('#closeNav').click(function() {
      $('.sidebar').width("0");
      $('#hiden-bar').show();
    });
});