scribble_draw(text, 0, x, y);
var _box = scribble_get_box(text,   x, y,   5, 5,   5, 5);
draw_rectangle(_box[SCRIBBLE_BOX.X0], _box[SCRIBBLE_BOX.Y0],
               _box[SCRIBBLE_BOX.X3], _box[SCRIBBLE_BOX.Y0]+200, true);



draw_set_font(spritefont);
draw_text(10, 10, test_string);
draw_set_font(-1);
scribble_draw(test_text, 0, 10, 30);