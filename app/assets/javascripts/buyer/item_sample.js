$(document).ready(function() {
    for (var i = 1; i <= 3; i++) {
        selector = "input#category_type" + i + "[type='checkbox']"
        if ($(selector).val() == 1) {
            ($(selector)).parent().css('background-color', '#fa1f6c');
        }
        if ($(selector).val() == 0) {
            ($(selector)).parent().css('background-color', '#fce696');
        }
    }
    selector = "input#category_type4[type='checkbox']"
    if ($(selector).val() == 1) {
        ($(selector)).parent().css('background-color', '#fa1f6c');
    }
    if ($(selector).val() == 0) {
        ($(selector)).parent().css('background-color', '#b4c7e8');
    }
    $('.js-sample').click(function() {
        id = $(this).attr('for')
        if ($('#' + id).val() == 1) {
            $(this).parent().css('background-color', '#fce696');
            $('#' + id).val(0)
        } else {
            $(this).parent().css('background-color', '#fa1f6c');
            $('#' + id).val(1)
        }
    })
    $('.js-sample-last').click(function() {
        id = $(this).attr('for')
        if ($('#' + id).val() == 1) {
            $(this).parent().css('background-color', '#b4c7e8');
            $('#' + id).val(0)
        } else {
            $(this).parent().css('background-color', '#fa1f6c');
            $('#' + id).val(1)
        }
    })
})