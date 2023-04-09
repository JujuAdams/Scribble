glyph = 32 + ((glyph + 1 - 32) mod (127-32));

draw_text(10, 10, "abcdefghijklmnopq");
draw_text(10, 80, chr(glyph));

var _x = 700;
var _y = 10;

draw_primitive_begin_texture(pr_trianglestrip, font_get_texture(global.font_add_font));
draw_vertex_texture(_x,                          _y,                          0, 0);
draw_vertex_texture(_x,                          _y + font_texture_page_size, 0, 1);
draw_vertex_texture(_x + font_texture_page_size, _y,                          1, 0);
draw_vertex_texture(_x + font_texture_page_size, _y + font_texture_page_size, 1, 1);
draw_primitive_end();

draw_rectangle(_x, _y, _x + font_texture_page_size, _y + font_texture_page_size, true);