$(document).ready(function(){
    $('.form-control--select2').select2({
        placeholder: '選択してください。',
        allowClear: true,
        // このオプションは、複数選択モードを有効にします。
        multiple: true,
        //追加を可能にします
        tags: true,
      });
      $("#btnSubmit").attr('disabled', 'disabled');
})