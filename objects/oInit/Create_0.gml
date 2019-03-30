//  Scribble v4.2.0
//  2019/03/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  Intended for use with GMS2.2.1 and later

//Start up Scribble and load some fonts
scribble_init_start( "Fonts", 2048 ); //Set to the same value as the texture page size for your target platform. GM uses 2048x2048 texture pages by default
scribble_init_add_font( "fTestA" ); //The first font added is the default font
scribble_init_add_font( "fTestB" );
scribble_init_add_spritefont( "sSpriteFont", 3 ); //GM's spritefont renderer handles spaces weirdly so it's best to specify a width
scribble_init_add_font( "fChineseTest" );
scribble_init_end();

//We're finished here, so destroy this instance and move to the next room
instance_destroy();
room_goto_next();