
// test
var time = current_time * 0.1;

// sprites
draw_sprite_stretched(IMAGE.spr_background, 0, 0, 0, room_width, room_height);
draw_sprite_ext(IMAGE.spr_background_two, 0, mouse_x, mouse_y, 1, 1, time, c_white, 1);
draw_sprite_ext(IMAGE.spr_mountains, 0, room_width-300, room_height-300, 1, 1, time*0.5, c_white, 1);

// fonts & texts
draw_set_font(FONT.fnt_game);
draw_set_color(c_black);
draw_text(31, 31, TEXT.text_information);
draw_set_color(c_white);
draw_text(30, 30, TEXT.text_information);

// surfaces
surface_set_target(IMAGE.surf_test);
draw_clear_alpha(c_black, 0);
draw_circle(256*abs(sin(current_time*0.001)), 64, 64, false);
surface_reset_target();
draw_surface(IMAGE.surf_test, 10, 150);
