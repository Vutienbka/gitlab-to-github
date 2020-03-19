function check_checked_box(button_apply, check_box_field_1, check_box_field_2) {
  $(button_apply).attr('disabled', ($(`${check_box_field_1}:checked`).prop('checked') && $(`${check_box_field_2}:checked`).prop('checked')) ? false : true);
}

$(document).ready(function() {
  check_checked_box('#button_apply', '#accept_rule_1', '#accept_rule_2');

  $('.checkbox-accept').click(function() {
    $(this).attr('checked', !$(this).attr('checked'));
    check_checked_box('#button_apply', '#accept_rule_1', '#accept_rule_2');
  });
})
