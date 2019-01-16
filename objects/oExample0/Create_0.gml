var _string  = "[fa_center]Welcome to the feature tour of\n[fTestB][rainbow]Scribble[/rainbow] " + SCRIBBLE_VERSION + "[]\nby [c_orange]@jujuadams[]";
    _string += "\n\n\n[fa_left][fTestA_bold]Scribble[] is a powerful and efficient text engine. It uses [fTestA_bold][wave]vertex buffers[] to precalculate the position of characters, and it uses [fTestA_bold][wave]shaders[] to animate sprites and letters.";
    _string += " By using fast GPU functions, [fTestA_bold]Scribble[] sidesteps the traditional, and clunky, native GameMaker text renderer.";
    _string += "\n\n[fa_center][shake][sCoin|1][c_red]Faster[] than [sSpriteFont]draw_text()[]";
    _string += "\n[shake][sCoin|0][c_yellow]Easier[] than a handwritten parser";
    _string += "\n[shake][sCoin|2][c_aqua]More flexible[] than prerendering to surfaces";
    _string += "\n[shake][sCoin|3][c_lime]Cross-platform[] and tested on consoles";
    _string += "\n[fa_right][fTiny](but not HTML5 <_<)[]";
    _string += "\n\n[fa_center]Press any key to begin.";

//Create a "scribble" data structure with a basic string
scribble = scribble_create( _string, 600 );

//Align the scribble so that the draw coordinate is in the middle of the box
scribble_set_box_alignment( scribble, fa_center, fa_middle );

//Place the textbox to the middle of the room
x = room_width/2;
y = room_height/2;

scribble_set_wave(  scribble, 1.5 );
scribble_set_shake( scribble, 2   );

line_pos = 0;