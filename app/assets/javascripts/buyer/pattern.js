$(document).ready(function() {
  var count = 1
  var sttasd = 0
  $('.hidden-field').each(function(){
    $(this).val(count++)
  })
  $('#pattern').on('cocoon:before-insert', function() {
    sttasd = $('div#pattern').find($('span.number-of-fields')).length
  })
  $('#pattern').on('cocoon:after-insert', function() {
    count = 1
    $('.hidden-field').each(function(){
      $(this).val(count++)
    })
    $('div#pattern').find($('span.number-of-fields:last')).text('パターン' +(sttasd + 1));
  })
 });