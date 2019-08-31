scribble_draw(x, y, text);

var _box = scribble_get_box(x, y,   text,   5, 5,   5, 5);
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);