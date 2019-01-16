//Start up Scribble and load some fonts
scribble_init_start();
scribble_init_add_font( "fTestA" ); //The first font added is the default font
scribble_init_add_font( "fTestA_bold" );
scribble_init_add_font( "fTestB" );
scribble_init_add_font( "fTiny" );
scribble_init_add_spritefont( "sSpriteFont" );
scribble_init_end();

//Modify the properties of some of the characters
scribble_font_char_set_width(   "sSpriteFont", " ", 3 );
scribble_font_char_set_x_shift( "sSpriteFont", " ", 3 );

scribble_font_char_add_x_shift( "sSpriteFont", "f", -1 );
scribble_font_char_add_x_shift( "sSpriteFont", "q", -1 );

//We're finished here so move to the next room
room_goto_next();