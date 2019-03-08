//Start up Scribble and load some fonts
scribble_init_start( 2048 ); //Set to the same value as the texture page size for your target platform
scribble_init_add_font( "fTestA" ); //The first font added is the default font
scribble_init_add_font( "fTestB" );
scribble_init_add_spritefont( "sSpriteFont" );
scribble_init_add_font( "fChineseTest" );
scribble_init_end();

//We're finished here, so destroy this instance and move to the next room
instance_destroy();
room_goto_next();