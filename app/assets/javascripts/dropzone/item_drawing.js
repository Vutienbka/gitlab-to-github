Dropzone.autoDiscover = false;
let id = $('.flex--file3').data('item-drawing');
let formData = new FormData();

$('.dropzone').each(function(){
  $(this).dropzone({
    url: "/buyers/item_requests/" + id + "/item_drawings/create",
    dictDefaultMessage: "<p>ここにファイルを<br>ドラッグアンドドロップ</p><p>または</p><label for='file_upload'>PCから<span class='textbr'>アップロード</span></label>",
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

      this.on("addedfile", function(file) {
        switch (myDropzone.element.id) {
          case 'myDropzone0':
            $("#btnSubmit").removeAttr('disabled');
            formData.append("item_drawing[file_specifications][" + this.files.length + "]", file);
            break;
          case 'myDropzone1':
            formData.append("item_drawing[file_assembly_specifications][" + this.files.length + "]", file);
            break;
          case 'myDropzone2':
            formData.append("item_drawing[file_packing_specifications][" + this.files.length + "]", file);
            break;
          default:
            break;
        }
        // Prevent upload duplicate files
        if (this.files.length) {
          var i, len;
          for (i = 0, len = this.files.length; i < len - 1; i++) {
            if (this.files[i].name === file.name && this.files[i].size === file.size && this.files[i].lastModifiedDate.toString() === file.lastModifiedDate.toString()) {
              alert("このファイル" + file.name + "が既に存在しています。");
              this.removeFile(file);
            }
          }
        }
      });
      this.on("removedfile", function(file) {
        if (myDropzone.files.length <= 0 && myDropzone.element.id == 'myDropzone0') {
          $("#btnSubmit").attr('disabled', 'disabled');
        }
      });
    }
  });
});

$(".continue-btn").on("click", function(e) {
  e.preventDefault();
  e.stopPropagation();

  $.ajax({
    url: "/buyers/item_requests/" + id + "/item_drawings/create",
    type: "POST",
    data:  formData,
    dataType: 'json',
    contentType: false,
    processData: false,
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    success: function(data) {
      window.location.href = "/buyers/item_requests/" + id + "/item_images/new"
    },
    error: function(jqXHR, textStatus, errorThrown) {
      console.log('AJAX call failed.');
      console.log(textStatus + ': ' + errorThrown);
    },
    complete: function() {
      console.log('AJAX call completed');
    }
  });
});

$(document).ready(function() {
  $("#btnSubmit").attr('disabled', 'disabled');
});