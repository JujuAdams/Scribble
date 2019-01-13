//Draw the JSON
scribble_draw( json,   x, y );

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_box( json,   x, y,   4, 4,   4, 4 );
draw_rectangle( _box[0], _box[1], _box[2], _box[3], true );



//Fun extra function that draws a cached vbuff
scribble_basic_draw_cached( "sSpriteFont", "The quick brown fox jumps over the lazy dog?", 10, 10 );

draw_set_font( sprite_font );
draw_text( 10, 30, "The quick brown fox jumps over the lazy dog?" );
draw_text( 345, 10, "The quick brown fox jumps over the lazy dog?" );

draw_sprite_stretched_ext( sPixel, 0, 10, 10, 1000, 1, c_red, 1 );
draw_sprite_stretched_ext( sPixel, 0, 10, 30, 1000, 1, c_red, 1 );
draw_sprite_stretched_ext( sPixel, 0, 10, 10, 1, 1000, c_red, 1 );