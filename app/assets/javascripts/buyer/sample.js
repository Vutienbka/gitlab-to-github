$(document).ready(function(){
	$('.get_sample_type').val(localStorage.getItem('get_sample_type'));
    $(document).on('click', '.choose_sample_type', function(){
			var sample_type = $(this).parents('.pass_sample_type').find('div').first().html();
			console.log(sample_type)
			localStorage.setItem('get_sample_type', sample_type)
    });
})
