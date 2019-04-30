//  Scribble v5.0.1
//  2019/04/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  For use with GMS2.2.2 and later

var _spritefont_map_string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

scribble_init("Fonts", "fTestA", true); //Start up Scribble and automatically load fonts stored in the "\Fonts" directory
scribble_define_spritefont("sSpriteFont", _spritefont_map_string, 0, 3); //GM's spritefont renderer handles spaces weirdly so it's best to specify a width

//We're finished here, so destroy this instance and move to the next room
instance_destroy();
room_goto_next();