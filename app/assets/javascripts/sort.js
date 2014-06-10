$(document).ready(function() {
	jQuery('#all_playlists').sortable({
		axis: "y",
		update: function(event, ui) {
			$.post($(this).data('update-url'), $(this).sortable('serialize'));
		}
	});
});

$(document).ready(function() {
	jQuery('#playlist_vids').sortable({
		axis: "y",
		update: function(event, ui) {
			$.post($(this).data('update-url'), $(this).sortable('serialize'));
		}
	});
});