draw_text(10, 10, "abcdefghijklmnopq");

glyph = 32 + ((glyph + 1 - 32) mod (127-32));
draw_text(10, 50, chr(glyph));

draw_primitive_begin_texture(pr_trianglestrip, font_get_texture(global.font_add_font));
draw_vertex_texture(300,                          0,                      0, 0);
draw_vertex_texture(300,                          font_texture_page_size, 0, 1);
draw_vertex_texture(300 + font_texture_page_size, 0,                      1, 0);
draw_vertex_texture(300 + font_texture_page_size, font_texture_page_size, 1, 1);
draw_primitive_end();