Dropzone.autoDiscover = false;

$('.dropzone').each(function(){ 
  let id = $(this).attr('id').replace('myDropzone', '')
  let item_request_id = $('#item_request_id').val();

  $(this).dropzone({
    url: "/buyers/item_standards",
    dictDefaultMessage: "PCからアップロード",
    params: {
      "item_request_id": item_request_id
    },
    paramName: "item_standard[standard_categories_attributes][" + id+ "][file_standard_attributes][file_link]",
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
        if (myDropzone.getQueuedFiles().length > 0) {
          e.preventDefault();
          e.stopPropagation();
          myDropzone.processQueue();
          return;
        }
      });
      this.on("sendingmultiple", function(data, xhr, formData) {
        formData.append("item_standard[standard_categories_attributes][" + id + "][name]", $('#item_standard_standard_categories_attributes_' + id + '_name').val());
        formData.append("item_standard[standard_categories_attributes][" + id + "][id]", $('#item_standard_standard_categories_attributes_' + id + '_id').val());
      });
      this.on("addedfile", function(file) {
        dropzone_uploaded_file(id);

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
      });
      this.on("removedfile", function(file) {
        if (myDropzone.files.length <= 0) {
          dropzone_no_file_upload(id);
        }
      });
      this.on("successmultiple", function(files, response) {
        window.location.href = "/buyers/item_conditions?item_request_id=" + item_request_id
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
