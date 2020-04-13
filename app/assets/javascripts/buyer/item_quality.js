$(document).ready(function() {
    for (var i = 1; i <= 16; i++) {
        selector = "input#quality" + i + "[type='checkbox']"
        quality = '#q-quality' + i
        if ($(quality).val() == null) {
            $(quality).val("0")
        }
        if ($(quality).val() == "1") {
            ($(selector)).parent().css('background-color', '#fa1f6c');
        }
        if ($(quality).val() == "0") {
            ($(selector)).parent().css('background-color', '#fce696');
        }
    }
    $('.js-quality').click(function() {
        id = $(this).attr('for')
        if ($('#q-' + id).val() == "1") {
            $(this).parent().css('background-color', '#fce696');
            $('#q-' + id).val("0")
        } else {
            $(this).parent().css('background-color', '#fa1f6c');
            $('#q-' + id).val("1")
        }
    })
})