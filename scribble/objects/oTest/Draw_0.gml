scribble_draw( test_json,   room_width/2, room_height/2 );

var _box = scribble_get_box( test_json,   room_width/2, room_height/2,   4, 4,   4, 4 );
draw_rectangle( _box[0], _box[1], _box[2], _box[3], true );

scribble_basic_draw_cached( "sSpriteFont", "The quick brown fox jumps over the lazy dog.", 10, 10 );