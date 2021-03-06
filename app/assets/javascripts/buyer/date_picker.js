$(document).ready(function () {
  $.datepicker._gotoToday = function (id) {
    var target = $(id);
    var inst = this._getInst(target[0]);
    var date = new Date();
    this._setDate(inst, date);
    this._hideDatepicker();
  }
  $.datepicker.regional['ja'] = {
    "closeText": "閉じる",
    "prevText": "Prev",
    "nextText": "Next",
    "currentText": "Today",
    "monthNames": [
      "1月",
      "2月",
      "3月",
      "4月",
      "5月",
      "6月",
      "7月",
      "8月",
      "9月",
      "10月",
      "11月",
      "12月"
    ],
    "monthNamesShort": [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ],
    "dayNames": [
      "日",
      "月",
      "火",
      "水",
      "木",
      "金",
      "土"
    ],
    "dayNamesShort": [
      "日",
      "月",
      "火",
      "水",
      "木",
      "金",
      "土"
    ],
    "dayNamesMin": [
      "日",
      "月",
      "火",
      "水",
      "木",
      "金",
      "土"
    ],
    "weekHeader": "Wk",
    "dateFormat": "mm/dd/yy",
    "firstDay": 0,
    "isRTL": false,
    "showMonthAfterYear": true,
    "yearSuffix": "年"
  };
  $.datepicker.setDefaults($.datepicker.regional['ja']);
  $('#select-period-from').datepicker({
    autoclose: false,
    showButtonPanel: true,
    language: 'ja',
    twentyFour: false, 
    dateFormat: 'dd-mm-yy',
    timeFormat: "hh:mm:ss",
    changeYear: true, // 年選択をプルダウン化
    onClose: function (dateText, inst) {
      if ($(window.event.srcElement).hasClass('ui-datepicker-close')) {
        document.getElementById(this.id).value = '';
      }
    }
  });

  // IOSか判定
  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {

    // 現在フォーカスが当たっているinput, textarea以外にreadonlyを設定
    $('#select-period-from').on('focus', function () {
      $('input, textarea').not(this).attr("readonly", "readonly");
    });

    // フォーカスが外れるときにreadonlyを外す
    $('#select-period-from').on('blur', function () {
      $('input, textarea').not(this).removeAttr("readonly");
    });
  }
  
  $('#select-period-to').datepicker({
    autoclose: false,
    language: 'ja',
    twentyFour: false, 
    showButtonPanel: true,
    dateFormat: 'dd-mm-yy',
    timeFormat: "hh:mm:ss",
    changeYear: true,  // 年選択をプルダウン化
    onClose: function (dateText, inst) {
      if ($(window.event.srcElement).hasClass('ui-datepicker-close')) {
        document.getElementById(this.id).value = '';
      }
    }
  });

  // IOSか判定
  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {

    // 現在フォーカスが当たっているinput, textarea以外にreadonlyを設定
    $('#select-period-to').on('focus', function () {
      $('input, textarea').not(this).attr("readonly", "readonly");
    });

    // フォーカスが外れるときにreadonlyを外す
    $('#select-period-to').on('blur', function () {
      $('input, textarea').not(this).removeAttr("readonly");
    });
  }

  $('#form-label-sample-delivery_time').datepicker({
    autoclose: false,
    language: 'ja',
    twentyFour: false, 
    showButtonPanel: true,
    dateFormat: 'dd-mm-yy',
    timeFormat: "hh:mm:ss",
    changeYear: true,  // 年選択をプルダウン化
    onClose: function (dateText, inst) {
      if ($(window.event.srcElement).hasClass('ui-datepicker-close')) {
        document.getElementById(this.id).value = '';
      }
    }
  });

  // IOSか判定
  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {

    // 現在フォーカスが当たっているinput, textarea以外にreadonlyを設定
    $('#form-label-sample-delivery_time').on('focus', function () {
      $('input, textarea').not(this).attr("readonly", "readonly");
    });

    // フォーカスが外れるときにreadonlyを外す
    $('#form-label-sample-delivery_time').on('blur', function () {
      $('input, textarea').not(this).removeAttr("readonly");
    });
  }


  $('#form-label-nouki').datepicker({
    autoclose: false,
    language: 'ja',
    twentyFour: false, 
    showButtonPanel: true,
    dateFormat: 'dd-mm-yy',
    timeFormat: "hh:mm:ss",
    changeYear: true,  // 年選択をプルダウン化
    onClose: function (dateText, inst) {
      if ($(window.event.srcElement).hasClass('ui-datepicker-close')) {
        document.getElementById(this.id).value = '';
      }
    }
  });

  // IOSか判定
  if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {

    // 現在フォーカスが当たっているinput, textarea以外にreadonlyを設定
    $('#form-label-nouki').on('focus', function () {
      $('input, textarea').not(this).attr("readonly", "readonly");
    });

    // フォーカスが外れるときにreadonlyを外す
    $('#form-label-nouki').on('blur', function () {
      $('input, textarea').not(this).removeAttr("readonly");
    });
  }
});
