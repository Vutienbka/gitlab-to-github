Dropzone.autoDiscover = false;

$('.dropzone').each(function(){ 
  let id = $(this).attr('id').replace('myDropzone', '')
  let item_request_id = $('#item_request_id').val();

  $(this).dropzone({
    url: "/buyers/item_images",
    dictDefaultMessage: "PCからアップロード",
    params: {
      "item_request_id": item_request_id
    },
    paramName: "item_image[image_categories_attributes][" + id+ "][file_image_attributes][file_link]",
    uploadMultiple: true,
    addRemoveLinks: true,
    autoProcessQueue: false,
    parallelUploads: 100,
    maxFiles: 100,
    acceptedFiles: ".jpeg,.jpg,.png,.gif",
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    init: function() {
      var myDropzone = this;
      $(".continue-btn").on("click", function(e) {
        e.preventDefault();
        e.stopPropagation();
        if (myDropzone.getQueuedFiles().length > 0) {
          myDropzone.processQueue();
          return;
        }
      });
      this.on("sendingmultiple", function(data, xhr, formData) {
        formData.append("item_image[image_categories_attributes][" + id + "][name]", $('#item_image_image_categories_attributes_' + id + '_name').val());
        formData.append("item_image[image_categories_attributes][" + id + "][id]", $('#item_image_image_categories_attributes_' + id + '_id').val());
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
        window.location.href = "/buyers/item_quality?item_request_id=" + item_request_id
      });
    }
  });
});

function dropzone_no_file_upload(id) {
  $("#dropzone_no_file_upload" + id).css("display", "block");
  $("#dropzone_file_uploaded" + id).css("display", "none");
}

function dropzone_uploaded_file(id) {
  $("#dropzone_no_file_upload" + id).css("display", "none");
  $("#dropzone_file_uploaded" + id).css("display", "block");
}

function check_dropzone_length() {
  if($('#dropzone_file_uploaded0').is(':visible')) {
    $("#btnSubmit").removeAttr('disabled');
  } else {
    $("#btnSubmit").attr('disabled', 'disabled');
  }
}

$(document).ready(function() {
  $("#btnSubmit").attr('disabled', 'disabled');
});
