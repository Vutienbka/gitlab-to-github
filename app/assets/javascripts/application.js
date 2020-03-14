// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery3
//= require jquery-ui
//= require_tree .

$(function () {
  $("#datepicker").datepicker({
    inline: true,
    firstDay: 1,
    altFormat: "m月d日 (D)",
    showOtherMonths: true,
    locale: 'ja',
    dayNamesMin: ["日", "月", "火", "水", "木", "金", "土"],
    yearSuffix: "年",
    showMonthAfterYear: true,
    monthNames: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
    changeYear: true
  });
});