//Update the text. This handles animation and events
scribble_step( text );

//Swap between fading in and fading out
if ( scribble_typewriter_get_state( text ) == 1 ) scribble_typewriter_out( text );
if ( scribble_typewriter_get_state( text ) == 2 ) scribble_typewriter_in( text );
//0 = State      : Text not yet faded in
//0 < State < 1  : Text is fading in
//1 = State      : Text fully visible
//1 < State < 2  : Text is fading out
//2 = State      : Text fully faded out

//Define a temporary string. This is the data Scribble will parse
var _string  = "[ev,sound,sndCrank][rainbow]abcdef[] [c_test]ABCDEF[]##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[sCoin][ev,sound,sndSwitch][sCoin,1][ev,sound,sndSwitch][sCoin,2][ev,sound,sndSwitch][sCoin,3][ev,sound,sndSwitch][shake][rainbow]!?[]\n\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]the [$FF4499][shake]QUICK [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE LAZY DOG.";

//Build Scribble data structure that describes how the text should be laid out
var _text = scribble_create( _string, -1, 450, "c_xanadu", "fTestB", fa_center );
scribble_destroy( _text );