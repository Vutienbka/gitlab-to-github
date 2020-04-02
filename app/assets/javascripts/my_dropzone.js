Dropzone.autoDiscover = false;

$('.dropzone').each(function(){ 
  let id = $(this).attr('id').replace('myDropzone', '')
  let item_request_id = $('#item_drawing_item_request_id').val();

  $(this).dropzone({
    url: "/buyers/item_drawings",
    dictDefaultMessage: "PCからアップロード",
    params: {
      "item_drawing[item_request_id]": item_request_id
    },
    paramName: "item_drawing[draw_categories_attributes][" + id+ "][file_draw_attributes][file_link]",
    uploadMultiple: true,
    addRemoveLinks: true,
    autoProcessQueue: false,
    parallelUploads: 100,
    maxFiles: 100,
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    init: function() {
      var myDropzone = this;

      $(".continue-btn").on("click", function(e) {
        e.preventDefault();
        e.stopPropagation();
        if (myDropzone.getQueuedFiles().length > 0) {
          dropzone_uploaded_file(id);
          check_dropzone_length();
          myDropzone.processQueue();
          return;
        } else {
          dropzone_no_file_upload(id);
        }
      });
      this.on("sendingmultiple", function(data, xhr, formData) {
        formData.append("item_drawing[draw_categories_attributes][" + id + "][name]", $('#item_drawing_draw_categories_attributes_' + id + '_name').val());
        formData.append("item_drawing[draw_categories_attributes][" + id + "][id]", $('#item_drawing_draw_categories_attributes_' + id + '_id').val());
      });
      this.on("addedfile", function(file) {
        dropzone_uploaded_file(id);
        check_dropzone_length();
      });
      this.on("removedfile", function(file) {
        if (myDropzone.files.length <= 0) {
          dropzone_no_file_upload(id);
          check_dropzone_length();
        }
      });
      this.on("successmultiple", function(files, response) {
        window.location.href = "/users/input_items_image?item_request_id=" + item_request_id
      });
    }
  });
});


function dropzone_no_file_upload(id) {
  $("#dropzone_no_file_upload" + id).css("display", "block");
  $("#dropzone_alert" + id).css("display", "none");
}

function dropzone_uploaded_file(id) {
  $("#dropzone_no_file_upload" + id).css("display", "none");
  $("#dropzone_alert" + id).css("display", "block");
}

function check_dropzone_length() {
  if($('#dropzone_alert0').is(':visible') && $('#dropzone_alert3').is(':visible')) {
    $("#btnSubmit").removeAttr('disabled');
  } else {
    $("#btnSubmit").attr('disabled', 'disabled');
  }
}

$(document).ready(function() {
  $("#btnSubmit").attr('disabled', 'disabled');
});
