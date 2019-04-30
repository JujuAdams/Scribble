//  Scribble v5.0.2
//  2019/04/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  For use with GMS2.2.2 and later

var _spritefont_map_string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

scribble_init("Fonts", "fTestA", true);
scribble_define_spritefont("sSpriteFont", _spritefont_map_string, 0, 3);

scribble_define_colour("c_coquelicot", $ff3800);
scribble_define_colour("c_smaragdine", $50c875);
scribble_define_colour("c_xanadu"    , $738678);
scribble_define_colour("c_amaranth"  , $e52b50);

instance_destroy();
room_goto_next();