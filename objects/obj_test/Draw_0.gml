var _bbox = element.get_bbox(x, y, 5, 5, 5, 5);
draw_rectangle(_bbox.left, _bbox.top, _bbox.right, _bbox.bottom, true);
draw_primitive_begin(pr_trianglestrip);
draw_vertex_color(_bbox.x0, _bbox.y0, c_gray, 1.0);
draw_vertex_color(_bbox.x1, _bbox.y1, c_gray, 1.0);
draw_vertex_color(_bbox.x2, _bbox.y2, c_gray, 1.0);
draw_vertex_color(_bbox.x3, _bbox.y3, c_gray, 1.0);
draw_primitive_end();

element.transform(1, 1, -15).typewriter_in(skip? 9999 : 1, 0).draw(x, y);

draw_set_font(spritefont);
draw_text(10, 10, test_string);
scribble("[spr_sprite_font]!" + test_string).draw(10 + string_width(test_string), 10);
scribble("[spr_sprite_font]" + test_string).draw(10, 30);
draw_set_font(-1);