//  Scribble v4.7.2
//  2019/07/08
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, DragoniteSpam, and sp202
//  
//  For use with GMS2.2.2 and later

scribble_init_start("Fonts", "fTestA", true);
scribble_init_add_spritefont("sSpriteFont", 3);
scribble_init_end();

scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

//You can define custom events that execute scripts
//Here's a basic example of playing a sound
scribble_add_event("sound", play_sound_example);

//Flags can be used to set formatting state which can be used to control text effects
//In this case, we're going to overwrite the default "shake" formatting flag with a new one called "rumble"
scribble_add_flag("rumble", 2);

//Add a new sprite from a file, then replace all instances of "[green coin]" with use GM's internal name for this sprite
var _new_sprite = sprite_add("green coin.png", 0, false, false, 0, 0);
scribble_replace_tag("green coin", sprite_get_name(_new_sprite));

//Some characters need a bit of fine adjustment in code since it's not always possible to fix this in the font itself
scribble_set_glyph_property("sSpriteFont", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("sSpriteFont", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

instance_destroy();
room_goto_next();