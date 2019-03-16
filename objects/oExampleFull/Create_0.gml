//  Scribble (light) v3.2.0
//  2019/03/16
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  Intended for use with GMS2.2.1 and later

//Define a temporary string. This is the data Scribble will parse
var _string  = "[ev,sound,sndCrank][rainbow]abcdef[] [c_test]ABCDEF[]##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[sCoin][ev,sound,sndSwitch][sCoin,1][ev,sound,sndSwitch][sCoin,2][ev,sound,sndSwitch][sCoin,3][ev,sound,sndSwitch][shake][rainbow]!?[]\n\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$FF4499][flag,1]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/flag,1]LAZY [fTestB]DOG.";

//Build Scribble data structure that describes how the text should be laid out
text = scribble_create( _string, -1, 450, "c_xanadu", "fTestB", fa_center );

//Set this text to be displayed typewriter style, fading in per character
scribble_typewriter_in( text, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER );

//Set how the text should be aligned relative to the draw coordinate
//Here, we're setting the alignment so that the middle/centre of the box is at the draw coordinate
scribble_set_box_alignment( text, fa_center, fa_middle );