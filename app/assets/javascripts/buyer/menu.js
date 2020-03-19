$(document).ready(function() {
    $('#hiden-bar').click(function() {
      $('.sidebar').width("15%");
      $('#full-content').width("85%")
      $('.fixed-footer').width("85%")
      $('.fixed-header-new').width("85%")
      $(this).hide()
      
      if ($(window).width()<1300) {
        $('.sidebar').width("20%");
        $('#full-content').width("80%")
        $('.fixed-footer').width("80%")
        $('.fixed-header-new').width("80%")
      }

      if ($(window).width()<768) {
        $('.sidebar').width("100%");
        $('#full-content').width("100%")
        $('.fixed-footer').width("100%")
        $('.fixed-header-new').width("100%")
      }

    });
    
    $('#closeNav').click(function() {
      $('.sidebar').width("0");
      $('#hiden-bar').show();
      $('#full-content').width("100%")
      $('.fixed-footer').width("100%")
      $('.fixed-header-new').width("100%")
    });
});