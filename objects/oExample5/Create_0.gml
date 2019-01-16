var _string  = "[c_red]Setting [c_orange]the [c_yellow]colour [c_lime]of [c_aqua]text [c_blue]is [c_fuchsia]easy[c_purple]!";
    _string += "\n\n[]Scribble also lets you use [$D2691E]custom hexcodes[] to choose colours.";
    _string += "\n\n[fTestA][fa_left]Font and alignment can also be [sSpriteFont]changed on the fly using command tags.";

//Create a "scribble" data structure with a basic string
scribble = scribble_create( _string, room_width, "fTestB", fa_center );

//Align the scribble so that the draw coordinate is in the middle of the box
scribble_set_box_alignment( scribble, fa_center, fa_middle );

//Place the textbox to the middle of the room
x = room_width/2;
y = room_height/2;