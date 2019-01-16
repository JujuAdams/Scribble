var _string  = "There are also some animated features:"
    _string += "\n\n[wave]waaaaaaaaaaaave\n\n[][rainbow]raaaaainbooooow";
    _string += "\n\n[]and [shake]shaaaakkkkkkkkkke[].";
    _string += "\n\n[wave][rainbow][shake]You can also stack effects!";

//Create a "scribble" data structure with a basic string
scribble = scribble_create( _string, room_width, "fTestB", fa_center );

//Align the scribble so that the draw coordinate is in the middle of the box
scribble_set_box_alignment( scribble, fa_center, fa_middle );

//Place the textbox to the middle of the room
x = room_width/2;
y = room_height/2;