//  Scribble v5.x.x
//  2019/07/08
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, DragoniteSpam, and sp202
//  
//  For use with GMS2.2.2 and later

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

scribble_init("Fonts", "fTestA", true);
scribble_add_spritefont("sSpriteFont", _mapstring, 0, 11);

scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

scribble_add_event("sound", example_play_sound);
scribble_add_event("pause", example_pause);
scribble_add_event("ping", example_ping);
scribble_add_flag("rumble", 2);
scribble_copy_tag("green coin", sprite_get_name(sprite_add("green coin.png", 0, false, false, 0, 0)));

scribble_set_glyph_property("sSpriteFont", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("sSpriteFont", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

room_goto_next();