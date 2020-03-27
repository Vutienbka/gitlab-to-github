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
        if (myDropzone.getQueuedFiles().length > 0) {
          e.preventDefault();
          e.stopPropagation();
          myDropzone.processQueue();
          return;
        }
      });
      this.on("sendingmultiple", function(data, xhr, formData) {
        formData.append("item_drawing[draw_categories_attributes][" + id + "][name]", $('#item_drawing_draw_categories_attributes_' + id + '_name').val());
        formData.append("item_drawing[draw_categories_attributes][" + id + "][id]", $('#item_drawing_draw_categories_attributes_' + id + '_id').val());
      });
      this.on("successmultiple", function(files, response) {
        window.location.href = "/users/input_items_image?item_request_id=" + item_request_id
      });
    }
  });
});