//  Scribble v4.2.0
//  2019/03/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  Intended for use with GMS2.2.1 and later

//Define a temporary string. This is the data Scribble will parse
var _string  = "[rainbow]abcdef[] ABCDEF##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[sCoin][sCoin,1][sCoin,2][sCoin,3][shake][rainbow]!?[]\n\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$FF4499][shake]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fTestB]DOG.";

//Build Scribble data structure that describes how the text should be laid out
//Since we're specifying what font to use, Scribble will use that font instead of the default (first font added during initialisation)
text = scribble_create( _string, -1, 450, c_teal, "fTestB" );