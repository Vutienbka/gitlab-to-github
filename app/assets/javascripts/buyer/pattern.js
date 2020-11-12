$(document).ready(function() {
  let count = 1;
  $( ".delete" ).prop( "disabled", true );
  $('.input-add').click(function(e) {
    var tbody = $('#pattern').clone();
    $('div#pattern-clone').append(tbody);
    tbody.find('input.field').attr('name', 'sample[patterns_attributes]['+ count +'][pattern]')
    if (count > 1){
      $( ".delete" ).removeAttr('disabled');
    }
    count++;
  });

  $('body').on('click', '.delete', function(){
    $(this).parents('div.input-group').remove();
    count--;
    if (count <= 1){
      $( ".delete" ).prop( "disabled", true );
    }
  });
});
    

