draw_text(10, 10, "abcdefghijklmnopq");
draw_text(10, 50, chr(glyph));

draw_primitive_begin_texture(pr_trianglestrip, font_get_texture(global.font_add_font));
draw_vertex_texture(1024,                          0,                      0, 0);
draw_vertex_texture(1024,                          font_texture_page_size, 0, 1);
draw_vertex_texture(1024 + font_texture_page_size, 0,                      1, 0);
draw_vertex_texture(1024 + font_texture_page_size, font_texture_page_size, 1, 1);
draw_primitive_end();

draw_rectangle(1024, 0, 1024 + font_texture_page_size, font_texture_page_size, true);

font_add_cache.__draw_debug(1024 + font_texture_page_size, 0,
                            1024 + font_texture_page_size + SCRIBBLE_FONT_ADD_CACHE_SIZE, SCRIBBLE_FONT_ADD_CACHE_SIZE);