//  Scribble v4.6.0
//  2019/04/12
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  For use with GMS2.2.2 and later

scribble_init("Fonts", "fTestA", true); //Start up Scribble and automatically load fonts stored in the "\Fonts" directory
scribble_define_spritefont("sSpriteFont", 3); //GM's spritefont renderer handles spaces weirdly so it's best to specify a width

//We're finished here, so destroy this instance and move to the next room
instance_destroy();
room_goto_next();