scribble_draw(text, x, y);

var _box = scribble_get_box(text,   x, y,   5, 5,   5, 5);
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);