//  Scribble v4.6.0
//  2019/04/12
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, and DragoniteSpam
//  
//  For use with GMS2.2.2 and later

//Start up Scribble and load some fonts
scribble_init_start("Fonts", "fTestA", true);
scribble_init_add_spritefont("sSpriteFont", 3); //GM's spritefont renderer handles spaces weirdly so it's best to specify a width
scribble_init_end();

//We're finished here, so destroy this instance and move to the next room
instance_destroy();
room_goto_next();