var _string  = "[rainbow]abcdef[] ABCDEF##";
    _string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sCoin,1][sCoin,2][sCoin,3][shake][rainbow]!?[]\n";
    _string += "[fa_centre][sCoin][sCoin][sCoin][sCoin]\n";
    _string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _string += "[fTestA][fa_right]THE [fTestB][$FF4499][shake]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fTestB]DOG.";

//Draw the text
var _scribble = scribble_draw_text(x - 150, y - 80, _string);

//Find the size and position of the bounding box (plus a bit) and draw it
var _box = scribble_get_box(_scribble,   x - 150, y - 80,   5, 5,   5, 5);

//scribble_get_box() return 4 coordinate pairs, one for each corner of the box
//This means you can rotate the textbox and still get useful coordinates
//Most of the time, you'll only want to use the top-left and bottom-right corners
draw_rectangle(_box[SCRIBBLE_BOX.TL_X], _box[SCRIBBLE_BOX.TL_Y],
               _box[SCRIBBLE_BOX.BR_X], _box[SCRIBBLE_BOX.BR_Y], true);