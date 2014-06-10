$(document).ready(function() {
	jQuery('#play_search').autocomplete({
		source: $('#play_search').data('autocomplete-source')
	});
});
//		source: $('#play_search').data('autocomplete_source')
