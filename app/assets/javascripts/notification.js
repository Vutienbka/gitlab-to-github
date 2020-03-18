function removeNotification() {
  var alert_dom = $('.alert');

  if (alert_dom.length > 0) {
    setTimeout(function() {
      $('.notification').fadeOut();
    }, 3000);
  } else {
    $('.notification').fadeOut();
  }
};
