//  Scribble v4.5.1
//  2019/04/12
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  For use with GMS2.2.2 and later

scribble_init_start("Fonts", "fTestA", true);
scribble_init_add_spritefont("sSpriteFont", 3);
scribble_init_end();

scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

instance_destroy();
room_goto_next();