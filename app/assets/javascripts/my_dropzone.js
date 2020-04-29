Dropzone.autoDiscover = false;

$('.dropzone').each(function(){
  let id = $(this).attr('id').replace('myDropzone', '')
  let item_request_id = $('#item_request_id').val();

  $(this).dropzone({
    url: "/buyers/item_drawings",
    dictDefaultMessage: "PCからアップロード",
    params: {
      "item_request_id": item_request_id
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
          $("#btnSubmit").attr('disabled', 'disabled');
          myDropzone.processQueue();
          $('body').addClass("loading");
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

        // Prevent upload duplicate files
        if (this.files.length) {
          var i, len, pre;
          for (i = 0, len = this.files.length; i < len - 1; i++) {
            if (this.files[i].name === file.name && this.files[i].size === file.size && this.files[i].lastModifiedDate.toString() === file.lastModifiedDate.toString()) {
              alert("このファイル" + file.name + "が既に存在しています。");
              this.removeFile(file);
              return (pre = file.previewElement) != null ? pre.parentNode.removeChild(file.previewElement) : void 0;
            }
          }
        }
        document.getElementById('dropzone_alert'+id).innerText = myDropzone.files.length
      });
      this.on("removedfile", function(file) {
        if (myDropzone.files.length <= 0) {
          dropzone_no_file_upload(id);
          check_dropzone_length();
        }
        document.getElementById('dropzone_alert'+id).innerText = myDropzone.files.length
      });
      this.on("successmultiple", function(files, response) {
        window.location.href = "/buyers/item_images?item_request_id=" + item_request_id
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
  $("#dropzone_alert" + id).css("display", "inline-block");
}

function check_dropzone_length() {
  if(($('#dropzone_alert0').is(':visible') || $('#dropzone_alert1').is(':visible') || $('#dropzone_alert2').is(':visible')) &&
      ($('#dropzone_alert3').is(':visible') || $('#dropzone_alert4').is(':visible') || $('#dropzone_alert5').is(':visible'))) {
    $("#btnSubmit").removeAttr('disabled');
  } else {
    $("#btnSubmit").attr('disabled', 'disabled');
  }
}

$(document).ready(function() {
  $("#btnSubmit").attr('disabled', 'disabled');
});
