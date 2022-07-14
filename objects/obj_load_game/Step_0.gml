
// loading progress
if package_contents_loaded(current_content) {
	// next content
	content_index += 1;
	if (content_index > array_length(content_list)-1) {
		// finished loading all contents
		if (!all_packages_loaded) {
			package_clean_cache();
			room_goto(rm_game);
			all_packages_loaded = true;
		}
	}
	
	// next content
	if (!all_packages_loaded) {
		current_content = content_list[content_index]();
	}
}
