scribble_draw(text, 0, x, y);

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_box(text,   x, y,   5, 5,   5, 5);

//scribble_get_box() return 4 coordinate pairs, one for each corner of the box
//This means you can rotate the textbox and still get useful coordinates
//Most of the time, you'll only want to use the top-left and bottom-right corners
draw_rectangle(_box[SCRIBBLE_BOX.X0], _box[SCRIBBLE_BOX.Y0],
               _box[SCRIBBLE_BOX.X3], _box[SCRIBBLE_BOX.Y3], true);