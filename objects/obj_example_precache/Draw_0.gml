scribble_set_box_align(fa_center, fa_middle);

//Draw our manually created Scribble data
scribble_draw(x, y, element);

//Find the size and position of the bounding box (plus a bit) and draw it
var _bbox = scribble_get_bbox(x, y, element,   5, 5, 5, 5);

scribble_reset();

//scribble_get_bbox() return 4 coordinate pairs, one for each corner of the box
//This means you can rotate the textbox and still get useful coordinates
//Most of the time, you'll only want to use the top-left and bottom-right corners
draw_rectangle(_bbox[SCRIBBLE_BBOX.L], _bbox[SCRIBBLE_BBOX.T],
               _bbox[SCRIBBLE_BBOX.R], _bbox[SCRIBBLE_BBOX.B], true);