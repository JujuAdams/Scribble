//  Scribble v4.1.0
//  2019/03/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  Intended for use with GMS2.2.1 and later

var _string  = "[rainbow]abcdef[] ABCDEF##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin][sCoin,1][sCoin,2][sCoin,3][shake][][rainbow]!?[]\n\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$FF4499][shake]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fTestB]DOG.";

text = scribble_create( _string, -1, 450, c_teal, "fTestB", fa_center );

//Set this text to be displayed typewriter style, fading in per character
scribble_typewriter_in( text, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 0.3 );

//Set how the text should be aligned relative to the draw coordinate
//Here, we're setting the alignment so that the middle/centre of the box is at the draw coordinate
scribble_set_box_alignment( text, fa_center, fa_middle );