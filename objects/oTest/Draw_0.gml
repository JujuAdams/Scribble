//Draw the JSON
scribble_draw( json,   room_width/2, room_height/2 );

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_box( json,   room_width/2, room_height/2,   4, 4,   4, 4 );
draw_rectangle( _box[0], _box[1], _box[2], _box[3], true );



//Fun extra function that draws a cached vbuff
scribble_basic_draw_cached( "sSpriteFont", "The quick brown fox jumps over the lazy dog.", 10, 10 );