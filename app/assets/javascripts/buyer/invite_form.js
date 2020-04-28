$(window).submit('beforeunload', function(e){
    if ($('#invite_email').val() === undefined || $('#invite_email').val() === '' ||
        $('#invite_company').val() === undefined || $('#invite_company').val() === ''
      ) {
    }
    else {
      $('body').addClass("loading");
    }
  });