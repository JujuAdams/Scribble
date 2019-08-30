//  Scribble v4.8.0
//  2019/07/08
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, DragoniteSpam, and sp202
//  
//  For use with GMS2.2.2 and later

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

//Start up Scribble and load some fonts
scribble_init("Fonts", "fTestA", true);
scribble_add_spritefont("sSpriteFont", _mapstring, 0, 3); //GM's spritefont renderer handles spaces weirdly so it's best to specify a width

//We're finished here, so destroy this instance and move to the next room
instance_destroy();
room_goto_next();