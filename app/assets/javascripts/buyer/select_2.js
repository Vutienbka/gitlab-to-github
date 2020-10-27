$(document).ready(function(){
    $('.form-control--select2').select2({
        placeholder: '選択してください。',
        allowClear: true,
        multiple: true,
        tags: true,
        include_blank: false
      });
})