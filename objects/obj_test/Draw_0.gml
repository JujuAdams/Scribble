scribble_draw_set_box_align(fa_center, fa_middle);
scribble_draw(x, y, element);

var _bbox = scribble_get_bbox(x, y, element,   5, 5, 5, 5);
draw_rectangle(_bbox[SCRIBBLE_BBOX.L], _bbox[SCRIBBLE_BBOX.T],
               _bbox[SCRIBBLE_BBOX.R], _bbox[SCRIBBLE_BBOX.B], true);

scribble_draw_reset();

draw_set_font(spritefont);
draw_text(10, 10, test_string);
scribble_draw(10 + string_width(test_string), 10, "[spr_sprite_font]!" + test_string);
scribble_draw(10, 30, "[spr_sprite_font]" + test_string);
draw_set_font(-1);