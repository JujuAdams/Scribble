scribble_font_set_default("fnt_test_0");
scribble_font_add_all();

scribble_typewriter_add_character_delay(",", 300);

//Create a "typist" which holds typewriter state
typist = scribble_typist();
typist.in(1, 0);

skip = false;