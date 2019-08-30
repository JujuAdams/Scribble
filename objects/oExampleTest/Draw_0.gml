scribble_draw(text, x, y);
var _box = scribble_get_box(text,   x, y,   0, 0,   0, 0);
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.BR_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);

draw_set_font(spritefont);
draw_text(10, 10, test_string);
draw_set_font(-1);
scribble_draw(test_text, 10, 30);