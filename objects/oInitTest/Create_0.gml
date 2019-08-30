//  Scribble v4.8.0
//  2019/07/08
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, DragoniteSpam, and sp202
//  
//  For use with GMS2.2.2 and later

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

scribble_init("Fonts", "fTestA", false);
scribble_add_font("fTestA");
scribble_add_font("fTestB");
scribble_add_font("fChineseTest", "CJK\\fChineseTest.yy");
scribble_add_spritefont("sSpriteFont", _mapstring, 0, 11);

scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

scribble_add_event("sound", play_sound_example);
scribble_add_event("pause", pause_example);
scribble_add_event("ping", ping_example);
scribble_add_flag("rumble", 2);
scribble_replace_tag("green coin", sprite_get_name(sprite_add("green coin.png", 0, false, false, 0, 0)));

scribble_set_glyph_property("sSpriteFont", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("sSpriteFont", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

instance_destroy();
room_goto_next();