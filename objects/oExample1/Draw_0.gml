//Draw the scribble
scribble_draw( scribble, x, y );

//Find the size and position of the bounding box and draw it
var _box = scribble_get_box( scribble,   x, y,   4, 4,   4, 4 );
draw_rectangle( _box[0], _box[1], _box[2], _box[3], true );