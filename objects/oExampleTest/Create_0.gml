//  Scribble v5.0.0
//  2019/04/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  For use with GMS2.2.2 and later

var _string  = "[sound,sndCrank][rainbow]TEST[] ABCDEF##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sound,sndSwitch][sCoin,1][sound,sndSwitch][sCoin,2][sound,sndSwitch][sCoin,3][sound,sndSwitch][][rumble][rainbow]!?[]\n";
    _string += "[sCoin][sCoin,1,0.1][sCoin,2,0.1][sCoin,3,0.1]\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$FF4499][rumble]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/rumble]LAZY [fTestB]DOG.";

text = scribble_create(_string, 450, -1, "c_xanadu", "fTestB", fa_center);
scribble_typewriter_in(text, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 0.3);
scribble_set_box_alignment(text, fa_center, fa_middle);

var _spritefont_map_string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

test_string = "The Quick Brown Fox Jumps Over The Lazy Dog!";
spritefont = font_add_sprite_ext(sSpriteFont, _spritefont_map_string, true, 0);
test_text = scribble_create(test_string, -1, -1, "c_white", "sSpriteFont", fa_left);