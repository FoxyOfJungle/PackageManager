

// [external] generate packages
package_images = package_create("Images");
package_add_sprite(package_images, "spr_background", spr_thing, 0);
package_add_sprite(package_images, "spr_background_two", spr_thing2, 0);
package_add_sprite(package_images, "spr_mountains", spr_thing3, 0);
package_add_surface(package_images, "surf_test", surface_create(256, 128));

package_fonts = package_create("Fonts");
package_add_font(package_fonts, "fnt_game", "Game_Files/Bromine.ttf", 24, false, false, 32, 128);

package_musics = package_create("Music");
package_add_file(package_musics, "music_level1", "Game_Files/music_level.ogg");
package_add_file(package_musics, "music_elevator", "Game_Files/music_elevator.ogg");

package_texts = package_create("Texts");
package_add_file(package_texts, "text_information", "Game_Files/some_text.txt");
package_add_file(package_texts, "readme", "Game_Files/awesome_readme.txt");

// save packages
package_save(package_images, "image_data");
package_save(package_fonts, "fonts_data");
package_save(package_musics, "music_data");
package_save(package_texts, "text_data");



// [in-game] load packages
package_images = package_load("image_data");
package_fonts = package_load("fonts_data");
package_musics = package_load("music_data");
package_texts = package_load("text_data");

global._image_contents = {};
global._font_contents = {};
global._music_contents = {};
global._text_contents = {};
#macro IMAGE global._image_contents
#macro FONT global._font_contents
#macro MUSIC global._music_contents
#macro TEXT global._text_contents



// content load queue
content_list = [
	function() {
		global._image_contents = package_get_contents(package_images);
		return global._image_contents;
	},
	function() {
		global._font_contents = package_get_contents(package_fonts);
		return global._font_contents;
	},
	function() {
		global._music_contents = package_get_contents(package_musics);
		return global._music_contents;
	},
	function() {
		global._text_contents = package_get_contents(package_texts);
		return global._text_contents;
	},
]
content_index = 0;
current_content = content_list[content_index](); // get first current content

// misc
all_packages_loaded = false;

