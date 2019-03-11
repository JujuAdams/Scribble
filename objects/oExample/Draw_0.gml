//Draw the text
scribble_draw( text, x, y );

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_box( text,   x, y,   5, 5,   5, 5 );

//scribble_get_box() return 4 coordinate pairs, one for each corner of the box
//This means you can rotate the textbox and still get useful coordinates
//Most of the time, you'll only want to use box[0],box[1] (top left) and box[6],box[7] (bottom right)
draw_rectangle( _box[0], _box[1], _box[6], _box[7], true );