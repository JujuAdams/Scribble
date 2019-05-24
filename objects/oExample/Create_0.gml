//  Scribble v4.7.1
//  2019/05/23
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, and DragoniteSpam
//  
//  For use with GMS2.2.2 and later

//Define a temporary string. This is the data Scribble will parse
var _string  = "[rainbow]abcdef[] ABCDEF##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sCoin,1][sCoin,2][sCoin,3][shake][rainbow]!?[]\n";
    _string += "[fa_centre][sCoin][sCoin][sCoin][sCoin]\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$ff4499][shake]QUICK[fTestA] [$d2691e]BROWN [$ff4499]FOX [fa_left]JUMPS OVER[$ffff00] THE [/shake]LAZY [fTestB]DOG.";

//Build Scribble data structure that describes how the text should be laid out
//Since we're specifying what font to use, Scribble will use that font instead of the default (first font added during initialisation)
text = scribble_create(_string, -1, 450, c_teal, "fTestB");