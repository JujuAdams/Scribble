//  Scribble v5.0.1
//  2019/04/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  For use with GMS2.2.2 and later

var _spritefont_map_string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

scribble_init("Fonts", "fTestA", false);
scribble_define_font("fTestA");
scribble_define_font("fTestB");
scribble_define_font("fChineseTest", "CJK\\fChineseTest.yy");
scribble_define_spritefont("sSpriteFont", _spritefont_map_string, 0, 11);

scribble_define_colour("c_coquelicot", $ff3800);
scribble_define_colour("c_smaragdine", $50c875);
scribble_define_colour("c_xanadu"    , $738678);
scribble_define_colour("c_amaranth"  , $e52b50);

scribble_define_event("sound", play_sound_example);
scribble_define_flag("rumble", 2);

scribble_set_glyph_property("sSpriteFont", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("sSpriteFont", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

instance_destroy();
room_goto_next();