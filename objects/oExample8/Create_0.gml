var _string  = "This is the end of the tour of the \"lite\" version of Scribble. [shake][c_aqua]:( :( :([]";
    _string += "\nThe [fTestB]full version[] includes [rainbow]hyperlinks[] and [rainbow]events[] to add extra polish to your text delivery.";

//Create a "scribble" data structure with a basic string
scribble = scribble_create( _string );

//Align the scribble so that the draw coordinate is in the middle of the box
scribble_set_box_alignment( scribble, fa_center, fa_middle );

//Place the textbox to the middle of the room
x = room_width/2;
y = room_height/2;