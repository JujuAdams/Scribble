//text = scribble_create(_string, -1, 450, "c_xanadu", "fnt_test_1", fa_center);
scribble_draw_set_fade(true, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);
scribble_draw_set_box_align(fa_center, fa_middle);
var _scribble = scribble_draw(x, y, demo_string);

var _box = scribble_get_bbox(_scribble,   x, y,   0, 0,   0, 0);
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);
scribble_draw_reset();


draw_set_font(spritefont);
draw_text(10, 10, test_string);
draw_set_font(-1);

scribble_draw(10, 30, "[spr_sprite_font]" + test_string);