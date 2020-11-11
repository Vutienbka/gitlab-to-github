$(document).ready(function(){
	get_local_storage($("#sample_category"), 'sample_category');
	get_local_storage($("#sample_supplier"), 'sample_supplier');
	get_local_storage($("#catalog"), 'catalog');
	get_local_storage($('.get-sample-type'), 'get_sample_type');

    $(document).on('click', '.choose_sample_type', function(){
			var sample_type = $(this).parents('.pass_sample_type').find('div').first().html();
			localStorage.setItem('get_sample_type', sample_type)
		});
		
		$(document).on('click', '#sample_category',function(){
			var sample_type = $(this).val();
			$.ajax({
				type: 'GET',
				url: '/buyers/samples/suppliers',
				dataType: 'json',
				data:{
					'sample_type': sample_type
				},
				headers: {
					"X-Transaction": "POST Example",
					"X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
				},
				success: function (data, textStatus, jqXHR) { },
				error: function (jqXHR, textStatus, errorThrown) { }
			}).done(function(data){
				var suppliers = data.suppliers
				var catalogs = data.catalogs
				if(suppliers.length > 0){
					add_append_for_array($("#sample_supplier"), suppliers);
				}else{
					localStorage.clear();
					add_append($("#sample_supplier"));
				}		
				if(catalogs.length > 0){
					add_append_for_array($("#catalog"), catalogs);
					}else{
						localStorage.clear();
						add_append($("#catalog"));
					}
				})
				.fail(function (data) {
					console.log('失敗しました');
				});
		});
		set_local_storage($("#sample_category"), 'sample_category');
		set_local_storage($("#sample_supplier"), 'sample_supplier');
		set_local_storage($("#catalog"), 'catalog');

		$(document).on('click', '#reset_filter', function(e){
			e.preventDefault();
			localStorage.clear();
			add_append($("#sample_category"));
			add_append($("#sample_supplier"));
			add_append($("#catalog"));
			$('#sample_filter').submit();
			$(this).submit();
		})

		function add_append(element){
			element.empty();
			element.append("<option value=''>全て</option>");
		}

		function set_local_storage(element, local_name){
			element.change(function(){
				var data = $(this).val();
				localStorage.setItem(local_name, data) 
			})
		}

		function get_local_storage(element, local_name){
			element.val(localStorage.getItem(local_name));
		}

		function add_append_for_array(element, data){
			add_append(element);
			for (var i = 0; i < data.length; i++) {
				element.append(
					'<option value="' +
					data[i] +
					'">' +
					data[i]+
					"</option>"
				);
				}
		}
})
