$(document).ready(function () {
    $("#search_catalog_buyer").on('input', function () {
      let availableTags = []
      $.ajax({
        type: "POST",
        url: "/suppliers/catalogs/search_auto",
        data: {
          'q': $(this).val()
        },
        datatype: "json",
        headers: {
          "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
        },
        success: function (data, textStatus, jqXHR) { },
        error: function (jqXHR, textStatus, errorThrown) { },
      }).done(function (data) {
        for (let i = 0; i < data.profile.length; i++) {
          availableTags.push(data.profile[i].first_name);
        }
        $("#search_catalog_buyer").autocomplete({
          source: availableTags
        });
      })
        .fail(function (data) {
          console.log('失敗しました');
        })
  
      
    });

    $("#search_catalog_auto").on('input', function () {
      let availableTags2 = []
      $.ajax({
        type: "POST",
        url: "/suppliers/catalogs/search_item_catalogs_auto",
        data: {
          'q': $(this).val()
        },
        datatype: "json",
        headers: {
          "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
        },
        success: function (data, textStatus, jqXHR) { },
        error: function (jqXHR, textStatus, errorThrown) { },
      }).done(function (data) {
        for (let i = 0; i < data.profile.length; i++) {
          availableTags2.push(data.profile[i].name);
        }
        $("#search_catalog_auto").autocomplete({
          source: availableTags2
        });
      })
        .fail(function (data) {
          console.log('失敗しました');
        })
  
      
    });
});