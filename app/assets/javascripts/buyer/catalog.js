$(document).ready(function () {
  var id;
  var catalog_name = 'カテゴリー名: ';
  var sub_catalog_name = 'サブカテゴリー名: ';
  var grandchild_catalog_name = '孫カテゴリー名: ';
  $(document).on('click', '.pass_data_to_modal', function () {
    id = $(this).attr('id').replace('pass_data_to_modal_', '');
    $.ajax({
      url: '/buyers/catalogs/get_catalog_after_click',
      type: 'GET',
      dataType: 'json',
      data: {
        'id': id
      },
      success: function (data) {
        if (data.level_type == 'parent')
          $('.choose-modal-title').text(catalog_name + data.name);
        else if ((data.level_type == 'sub_catalog')) {
          $('.choose-modal-title').text(sub_catalog_name + data.name);
        } else {
          $('.choose-modal-title').text(grandchild_catalog_name + data.name);
        }

      }
    })
  })

  var form_edit_action = $('#catalog_form_edit').attr('action')
  var form_delete_action = $('#catalog_form_delete').attr('action')
  var catalog_edit_url = form_edit_action;
  var catalog_delete_url = form_delete_action;

  $(document).on('click', '.edit-catalog', function () {
    $.ajax({
      url: '/buyers/catalogs/get_selected_catalog',
      type: 'GET',
      dataType: 'json',
      data: {
        'catalog_id': id
      },
      success: function (data) {
        $('#form-modal-subcategory').val(data.name)
        $('.edit-modal-title-catalog').text(catalog_name + data.name)
      }
    })
    catalog_edit_url = form_edit_action + '/' + id;
    $('#catalog_form_edit').attr('action', catalog_edit_url);
  })

  $(document).on('click', '.delete-catalog', function () {
    catalog_delete_url = form_delete_action + '/' + id;
    $('#catalog_form_delete').attr('action', catalog_delete_url);
    $('.delete-modal-title-catalog').text($('.choose-modal-title').html());
  })

  $(document).on('click', '.edit-sub-catalog', function () {
    var sub_id = id;
    var catalog_id = $('#catalog_id').val();
    $.ajax({
      url: '/buyers/catalogs/' + catalog_id + '/sub_catalogs/get_selected_sub_catalog',
      type: 'GET',
      dataType: 'json',
      data: {
        'sub_catalog_id': sub_id
      },
      success: function (data) {
        console.log(data)
        $('#form-modal-subcategory').val(data.name)
        $('.edit-modal-title-sub-catalog').text(sub_catalog_name + data.name)
      }
    })
    catalog_edit_url = form_edit_action + '/sub_catalogs/' + sub_id;
    $('#catalog_form_edit').attr('action', catalog_edit_url);
  })

  $(document).on('click', '.delete-sub-catalog', function () {
    var sub_id = id;
    catalog_delete_url = form_delete_action + '/sub_catalogs/' + sub_id;
    $('#catalog_form_delete').attr('action', catalog_delete_url);
    $('.delete-modal-title-sub-catalog').text($('.choose-modal-title').html());
  })

  $(document).on('click', '.edit-grandchild-catalog', function () {
    var grandchild_id = id;
    var catalog_id = $('#catalog_id').val();
    var sub_catalog_id = $('#sub_catalog_id').val();
    $.ajax({
      url: '/buyers/catalogs/' + catalog_id + '/sub_catalogs/' + sub_catalog_id + '/grandchild_catalogs/get_selected_grandchild_catalog',
      type: 'GET',
      dataType: 'json',
      data: {
        'grandchild_catalog_id': grandchild_id
      },
      success: function (data) {
        $('#form-modal-subcategory').val(data.name)
        $('.edit-modal-title-grandchild-catalog').text(grandchild_catalog_name + data.name)
      }
    })

    catalog_edit_url = form_edit_action + '/' + grandchild_id;
    $('#catalog_form_edit').attr('action', catalog_edit_url);
  })

  $(document).on('click', '.delete-grandchild-catalog', function () {
    var grandchild_id = id;
    catalog_delete_url = form_delete_action + '/' + grandchild_id;
    $('#catalog_form_delete').attr('action', catalog_delete_url);
    $('.delete-modal-title-grandchild-catalog').text($('.choose-modal-title').html());
  })
})