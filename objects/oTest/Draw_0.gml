//text = scribble_create(_string, -1, 450, "c_xanadu", "fTestB", fa_center);
var _string  = "[sound,sndCrank][rainbow]TEST[] [slant]AaBbCcDdEeFf[/slant]##";
    _string += "a b c d e f g h i j k l m n o p q r s t u v w x y z\n\n";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sound,sndSwitch][sCoin,1][sound,sndSwitch][sCoin,2][sound,sndSwitch][sCoin,3][sound,sndSwitch][][rumble][rainbow]!?[]\n";
    _string += "[sCoin][sCoin,1,0.1][sCoin,2,0.1][sCoin,3,0.1]    [green coin]\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$FF4499][rumble]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] [/rumble]THE LAZY [fTestB]DOG.";

scribble_set_typewriter(true, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);
scribble_set_box_alignment(fa_center, fa_middle);
var _scribble = scribble_draw(x, y, _string);

var _box = scribble_get_box(_scribble,   x, y,   0, 0,   0, 0);
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);
scribble_set_state();


draw_set_font(spritefont);
draw_text(10, 10, test_string);
draw_set_font(-1);

scribble_draw(10, 30, "[sSpriteFont]" + test_string);