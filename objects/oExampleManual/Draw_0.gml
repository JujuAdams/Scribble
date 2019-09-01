scribble_set_typewriter(true, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);
scribble_set_box_alignment(fa_center, fa_middle);
scribble_draw(x, y, scribble);
scribble_set_state();

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_box(scribble,   x, y,   5, 5,   5, 5);

//scribble_get_box() return 4 coordinate pairs, one for each corner of the box
//This means you can rotate the textbox and still get useful coordinates
//Most of the time, you'll only want to use the top-left and bottom-right corners
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);