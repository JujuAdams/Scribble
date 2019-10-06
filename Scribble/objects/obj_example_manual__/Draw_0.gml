scribble_draw_set_box_align(fa_center, fa_middle);
scribble_draw(x, y, scribble);
var _box = scribble_get_bbox(scribble,   x, y,   5, 5,   5, 5);
scribble_draw_reset();

draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);