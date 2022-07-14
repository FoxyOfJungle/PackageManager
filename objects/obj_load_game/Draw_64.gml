
// progress
var _status = package_contents_get_progress(current_content);

// loading bar
var _ww = 200;
var _xx = display_get_gui_width() / 2;
var _yy = display_get_gui_height() - 128;
draw_sprite_stretched(spr_healthbar, 0, _xx-_ww/2, _yy, _ww, 24);
draw_sprite_stretched(spr_healthbar, 1, _xx-_ww/2, _yy, _ww*_status.progress, 24);

draw_set_halign(fa_center);
draw_text(_xx, _yy-32, "Loading | " + string(round(_status.progress*100)) + "%");
draw_text(_xx, _yy+32, _status.current_resource);
draw_set_halign(fa_left);
