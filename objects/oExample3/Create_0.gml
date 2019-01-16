var _string = "This text is rendered using a larger font.\n\nThe textbox is also centred to the middle of the room using the scribble_set_box_alignment() function.";

//Create a "scribble" data structure with a basic string
scribble = scribble_create( _string, room_width, "fTestB" );

//Align the scribble so that the draw coordinate is in the middle of the box
scribble_set_box_alignment( scribble, fa_middle, fa_center );

//Place the textbox to the middle of the room
x = room_width/2;
y = room_height/2;