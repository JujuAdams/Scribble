var _string = "This text is rendered using a spritefont.\nIt's also revealled progressively as you'd see in many RPGs and narrative games!";

//Create a "scribble" data structure with a basic string
scribble = scribble_create( _string, room_width, "sSpriteFont", fa_center );

//Align the scribble so that the draw coordinate is in the middle of the box
scribble_set_box_alignment( scribble, fa_center, fa_middle );

//Place the textbox to the middle of the room
x = room_width/2;
y = room_height/2;

//Variable to track which character of the string we've revealed
char_pos = 0;