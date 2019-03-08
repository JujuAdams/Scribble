//Define a temporary string. This is the data Scribble will parse to make a JSON
var _string = "[ev|sound|sndCrank][rainbow]abcdef[] ABCDEF##[wave][c_orange]0123456789[] .,<>\"'&[sCoin|$0][ev|sound|sndSwitch][sCoin|$1][ev|sound|sndSwitch][sCoin|$0][ev|sound|sndSwitch][sCoin|1][ev|sound|sndSwitch][shake][rainbow]!?[]\n\n[link|0]the quick[/link] [link|1]brown fox[/link] [wave]jumps[] over the lazy dog\n\n[fa_right]THE [$FF4499][shake]QUICK [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER []THE LAZY DOG.";

//Build a JSON that describdes how the text should be laid out
//This script also (by default) builds vertex buffers to draw the text
json = scribble_create( _string, 200, 0.2, "sSpriteFont", fa_center, make_colour_hsv( 35, 140, 210 ) );

//Set how the text should be aligned relative to the draw coordinate
//Here, we're setting the alignment so that the middle/centre of the box is at the draw coordinate
scribble_set_box_alignment( json, fa_center, fa_middle );

//Set properties for sprite slots. Sprite slots are used to animate sprites
//By default, there is a maximum of 4 sprite slots
scribble_set_sprite_slot_speed( json, 0, 0.1 );
scribble_set_sprite_slot_image( json, 1, 1   );
scribble_set_sprite_slot_speed( json, 1, 0.2 );