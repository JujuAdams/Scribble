//Draw the JSON
scribble_draw( json, x, y, 1, 1, current_time/30, c_white, 1 );

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_box( json,   x, y,   4, 4,   4, 4 );
draw_rectangle( _box[0], _box[1], _box[2], _box[3], true );