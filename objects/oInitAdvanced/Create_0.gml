//  Scribble v5.0.0
//  2019/04/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  For use with GMS2.2.2 and later

scribble_init("Fonts", "fTestA", true);
scribble_define_spritefont("sSpriteFont", 3);

scribble_define_colour("c_coquelicot", $ff3800);
scribble_define_colour("c_smaragdine", $50c875);
scribble_define_colour("c_xanadu"    , $738678);
scribble_define_colour("c_amaranth"  , $e52b50);

//You can define custom events that execute scripts
//Here's a basic example of playing a sound
scribble_define_event("sound", play_sound_example);

//Flags can be used to set formatting state which can be used to control text effects
//In this case, we're going to overwrite the default "shake" formatting flag with a new one called "rumble"
scribble_define_flag("rumble", 2);

//Some characters need a bit of fine adjustment in code since it's not always possible to fix this in the font itself
scribble_set_glyph_property("sSpriteFont", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("sSpriteFont", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

instance_destroy();
room_goto_next();