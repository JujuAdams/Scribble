scribble_set_box_align(fa_center, fa_middle, true);
scribble_set_transform(1, 1, -15);

var _bbox = scribble_get_bbox(x, y, element,   5, 5, 5, 5);
draw_primitive_begin(pr_trianglestrip);
draw_vertex_color(_bbox[SCRIBBLE_BBOX.X0], _bbox[SCRIBBLE_BBOX.Y0], c_gray, 1.0);
draw_vertex_color(_bbox[SCRIBBLE_BBOX.X1], _bbox[SCRIBBLE_BBOX.Y1], c_gray, 1.0);
draw_vertex_color(_bbox[SCRIBBLE_BBOX.X2], _bbox[SCRIBBLE_BBOX.Y2], c_gray, 1.0);
draw_vertex_color(_bbox[SCRIBBLE_BBOX.X3], _bbox[SCRIBBLE_BBOX.Y3], c_gray, 1.0);
draw_primitive_end();

scribble_draw(x, y, element);

scribble_reset();

draw_set_font(spritefont);
draw_text(10, 10, test_string);
scribble_draw(10 + string_width(test_string), 10, "[spr_sprite_font]!" + test_string);
scribble_draw(10, 30, "[spr_sprite_font]" + test_string);
draw_set_font(-1);