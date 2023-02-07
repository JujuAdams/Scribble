if (keyboard_check_pressed(vk_escape)) instance_destroy();
if (keyboard_check_pressed(ord("T"))) draw_texture_flush();
if (keyboard_check_pressed(ord("S"))) font_enable_sdf(global.font_add_font, !font_get_sdf_enabled(global.font_add_font));