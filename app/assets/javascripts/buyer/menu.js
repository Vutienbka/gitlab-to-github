$(document).ready(function() {
    $('#hiden-bar').click(function() {
      $('.sidebar').width("15%");
      $('#full-content').css({"margin-left":"15%"})
      $('.fixed-footer').width("85%")
      $('.fixed-header-new').css({"width":"85%"})
      $(this).hide()
      
      if ($(window).width()<1300) {
        $('.sidebar').width("20%");
        $('#full-content').css({"margin-left":"20%"})
        $('.fixed-footer').width("80%")
        $('.fixed-header-new').css({"width":"80%"})
      }

      if ($(window).width()<768) {
        $('.sidebar').width("75%");
        $('#full-content').width("100%")
        $('.fixed-footer').width("100%")
        $('#full-content').css({"margin-left":"0%"})
        $('.fixed-header-new').css({"width":"100%"})
      }

    });
    
    $('#closeNav').click(function() {
      $('.sidebar').width("0");
      $('#hiden-bar').show();
      $('#full-content').css({"margin-left":"0%"})
      $('.fixed-footer').width("100%")
      $('.fixed-header-new').css({"width":"100%"})
    });
});