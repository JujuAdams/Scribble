//  Scribble v4.7.1
//  2019/05/23
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, and DragoniteSpam
//  
//  For use with GMS2.2.2 and later

scribble_init("Fonts", "fTestA", true); //Start up Scribble and load some fonts
scribble_define_spritefont("sSpriteFont", 3); //GM's spritefont renderer handles spaces weirdly so it's best to specify a width

//We're finished here, so destroy this instance and move to the next room
instance_destroy();
room_goto_next();