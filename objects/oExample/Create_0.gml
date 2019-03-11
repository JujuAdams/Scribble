//  Scribble (light) v2.5.5
//  2019/03/11
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  Intended for use with GMS2.2.1 and later

//Define a temporary string. This is the data Scribble will parse
var _string  = "[ev,sound,sndCrank][rainbow]abcdef[] [c_test]ABCDEF[]##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[sCoin][ev,sound,sndSwitch][sCoin,1][ev,sound,sndSwitch][sCoin,2][ev,sound,sndSwitch][sCoin,3][ev,sound,sndSwitch][shake][rainbow]!?[]\n\n";
    _string += "the quick brown fox [wave]jumps[] over the lazy dog";
    _string += "[fa_right]the [$FF4499][shake]QUICK [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER []THE LAZY DOG.";

//Build Scribble data structure that describes how the text should be laid out
text = scribble_create( _string, 450, "fTestB", fa_center, make_colour_hsv( 35, 140, 210 ) );

//Set this text to be displayed typewriter style, fading in per character
scribble_typewriter_in( text, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER );

//Set how the text should be aligned relative to the draw coordinate
//Here, we're setting the alignment so that the middle/centre of the box is at the draw coordinate
scribble_set_box_alignment( text, fa_center, fa_middle );