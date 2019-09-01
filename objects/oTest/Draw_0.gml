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

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_box(_scribble,   x, y,   0, 0,   0, 0);

//scribble_get_box() return 4 coordinate pairs, one for each corner of the box
//This means you can rotate the textbox and still get useful coordinates
//Most of the time, you'll only want to use the top-left and bottom-right corners
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);