//  Scribble v4.7.1
//  2019/05/23
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, and DragoniteSpam
//  
//  For use with GMS2.2.2 and later

var _string  = "[c_teal][fTestB][fa_center][rainbow]abcdef[] ABCDEF##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sCoin,1][sCoin,2][sCoin,3][shake][][rainbow]!?[]\n";
    _string += "[fa_centre][sCoin][sCoin][sCoin][sCoin]\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$ff4499][shake]QUICK[fTestA] [$d2691e]BROWN [$ff4499]FOX [fa_left]JUMPS OVER[$ffff00] THE [/shake]LAZY [fTestB]DOG.";

text = scribble_static_create(_string, -1, 450);

//Set this text to be displayed typewriter style, fading in per character
scribble_typewriter_in(text, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 0.3);

//Set how the text should be aligned relative to the draw coordinate
//Here, we're setting the alignment so that the middle/centre of the box is at the draw coordinate
scribble_set_box_alignment(text, fa_center, fa_middle);