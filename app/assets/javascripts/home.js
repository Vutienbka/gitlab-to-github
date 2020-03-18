$(document).ready(function () {
  setHeightLeftMenu();

  $("#datepicker-left-menu").datepicker({
    inline: true,
    firstDay: 1,
    altFormat: "m月d日 (D)",
    showOtherMonths: true,
    locale: 'ja',
    dayNamesMin: ["日", "月", "火", "水", "木", "金", "土"],
    yearSuffix: "年",
    showMonthAfterYear: true,
    monthNames: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
    changeYear: true,
    onSelect: function (e) {
      var date = convert_date($(this).datepicker('getDate'));
      $.ajax({
        url: '/calendar/show_calendar',
        method: 'GET',
        dataType: 'script',
        data: {
          start_date: date
        }
      });
    }
  });
});

function setHeightLeftMenu() {
  height = $('.contents').height() + $('.header').height();
  $('.main-menu').css('height', height + 'px');
}

function convert_date(fullDate) {
  var twoDigitMonth = fullDate.getMonth() + 1 + "";
  if (twoDigitMonth.length == 1)
		twoDigitMonth = "0" + twoDigitMonth;
  var twoDigitDate = fullDate.getDate() + "";
  if (twoDigitDate.length == 1)
    twoDigitDate = "0" + twoDigitDate;
  var currentDate = twoDigitDate + "/" + twoDigitMonth + "/" + fullDate.getFullYear();
  return currentDate;
}
