var _text = string_char_at(source, glyph+1);

draw_text(10, 10, _text);
draw_line(0, 10, room_width, 10);
draw_text(10, 40, "Hello world!");
draw_line(0, 40, room_width, 40);

scribble(_text).draw(10, 210);
draw_line(0, 210, room_width, 210);
scribble("Hello world!").draw(10, 240);
draw_line(0, 240, room_width, 240);

draw_line(10, 0, 10, room_height);

//draw_text(10, 150, "font_texture_page_size = " + string(font_texture_page_size));

var _x = 512;

shader_set(shd_alpha_to_colour);
draw_primitive_begin_texture(pr_trianglestrip, font_get_texture(global.font_add_font));
draw_vertex_texture(_x,                          0,                      0, 0);
draw_vertex_texture(_x,                          font_texture_page_size, 0, 1);
draw_vertex_texture(_x + font_texture_page_size, 0,                      1, 0);
draw_vertex_texture(_x + font_texture_page_size, font_texture_page_size, 1, 1);
draw_primitive_end();
shader_reset();

draw_rectangle(_x, 0, _x + font_texture_page_size, font_texture_page_size, true);

_x += font_texture_page_size;

shader_set(shd_alpha_to_colour);
__scribble_get_font_data("OpenHuninn")
.__font_add_cache_array[SCRIBBLE_FONT_GROUP.FALLBACK]
.__draw_debug(
    _x, 0,
    _x + SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE, SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE
);
shader_reset();