//Start up Scribble and load fonts automatically from Included Files
scribble_init("Fonts", "fTestA", true);

//Add a spritefont to Scribble
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("sSpriteFont", _mapstring, 0, 3); //GM's spritefont renderer handles spaces weirdly so it's best to specify a width

//Define a demo string for use in the Draw event
demo_string  = "[rainbow]abcdef[] ABCDEF##";
demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sCoin,1][sCoin,2][sCoin,3][shake][rainbow]!?[]\n";
demo_string += "[fa_centre][sCoin][sCoin][sCoin][sCoin]\n";
demo_string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
demo_string += "[fTestA][fa_right]THE [fTestB][$FF4499][shake]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fTestB]DOG.";