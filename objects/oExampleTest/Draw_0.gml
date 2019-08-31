scribble_draw(x, y, text);
var _box = scribble_get_box(x, y,   text,   0, 0,   0, 0);
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);

draw_set_font(spritefont);
draw_text(10, 10, test_string);
draw_set_font(-1);
scribble_draw(10, 30, test_text);