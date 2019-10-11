scribble_draw_set_box_align(fa_center, fa_middle);

//Draw our manually created Scribble data
scribble_draw(x, y, element);

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_bbox(element,   x, y,   5, 5,   5, 5);

scribble_draw_reset();

//scribble_get_bbox() return 4 coordinate pairs, one for each corner of the box
//This means you can rotate the textbox and still get useful coordinates
//Most of the time, you'll only want to use the top-left and bottom-right corners
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);