//scribble_draw_static(text, x, y);
//var _box = scribble_get_box(text,   x, y,   0, 0,   0, 0);
//draw_rectangle(_box[SCRIBBLE_BOX.X0], _box[SCRIBBLE_BOX.Y0],
//               _box[SCRIBBLE_BOX.X3], _box[SCRIBBLE_BOX.Y3], true);
//
//draw_set_font(spritefont);
//draw_text(10, 10, test_string);
//draw_set_font(-1);
//scribble_draw_static(test_text, 10, 30);

var _string  = "[fa_center][fa_middle][fa_left][c_xanadu][fTestB][sound,sndCrank][rainbow][thick,0.5]T[thick,0.33]E[thick,0.16]S[/thick]T[] [wobble]ABCDEF[/wobble]##";
    _string += "a b c d e f g h i j k [thick]l m n o p q[/thick] r s t u v w x y z\n\n";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sound,sndSwitch][sCoin,1][sound,sndSwitch][sCoin,2][sound,sndSwitch][sCoin,3][sound,sndSwitch][][rumble][rainbow]!?[]\n";
    _string += "[sCoin,0,0.1][sCoin,1,0.1][sCoin,2,0.1][sCoin,3,0.1]    [green coin]\n";
    _string += "[sSpriteFont][thick]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$ff4499][rumble]QUICK[fTestA] [$d2691e]BROWN [$ff4499]FOX [fa_left]JUMPS OVER[$ffff00] [/rumble]THE LAZY [fTestB]DOG.";

scribble_draw(x, y, _string);