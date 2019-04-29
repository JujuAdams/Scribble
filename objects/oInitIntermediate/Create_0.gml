//  Scribble v5.0.0
//  2019/04/12
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

instance_destroy();
room_goto_next();