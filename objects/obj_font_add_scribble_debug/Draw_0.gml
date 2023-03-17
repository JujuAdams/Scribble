var _text = chr(glyph);
draw_text(10, 10, _text);
scribble(_text).draw(10, 40);
draw_text(10, 70, "font_texture_page_size = " + string(font_texture_page_size));

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
__scribble_get_font_data("NotoSans").__font_add_cache.__draw_debug(
    _x, 0,
    _x + SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE, SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE
);
shader_reset();