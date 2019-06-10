//  Scribble v4.7.1
//  2019/05/21
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, and DragoniteSpam
//  
//  For use with GMS2.2.2 and later

var _string  = "[c_xanadu][fTestB][fa_center][sound,sndCrank][rainbow][thick,0.5]T[thick,0.33]E[thick,0.16]S[/thick]T[] [wobble]ABCDEF[/wobble]##";
    _string += "a b c d e f g h i j k [thick]l m n o p q[/thick] r s t u v w x y z\n\n";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sound,sndSwitch][sCoin,1][sound,sndSwitch][sCoin,2][sound,sndSwitch][sCoin,3][sound,sndSwitch][][rumble][rainbow]!?[]\n";
    _string += "[sCoin,0,0.1][sCoin,1,0.1][sCoin,2,0.1][sCoin,3,0.1]    [green coin]\n";
    _string += "[sSpriteFont][thick]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$ff4499][rumble]QUICK[fTestA] [$d2691e]BROWN [$ff4499]FOX [fa_left]JUMPS OVER[$ffff00] [/rumble]THE LAZY [fTestB]DOG.";

text = scribble_create_static(_string, -1, 450);
scribble_set_animation(text,   4, 50, 0.2,   4, 0.4,   0.5, 0.01,   40, 0.15,   0.4, 0.1);
scribble_typewriter_in(text, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 0.3, 3);
scribble_set_box_alignment(text, fa_center, fa_middle);

var _spritefont_map_string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

test_string = "[c_white][sSpriteFont][fa_left]The Quick Brown Fox Jumps Over The Lazy Dog!";
spritefont = font_add_sprite_ext(sSpriteFont, _spritefont_map_string, true, 0);
test_text = scribble_create_static(test_string, -1, -1);