var _string  = "[fTestB]Scribble also[sCoin]supports in-line[sCoin|1]sprite drawing[sCoin|2]using command tags[sCoin|3][]";
    _string += "\n\n[sCoin|$0]Sprites are static by default but can be animated using \"sprite slots\"[sCoin|$0]";
    _string += "\n\nUp to four sprite slots are available by default [sCoin|$0] [sCoin|$1] [sCoin|$2] [sCoin|$3]";
    _string += "\n\n[sCoin|$1]Multiple[sCoin|$1]sprites[sCoin|$1]can[sCoin|$1]share[sCoin|$1]the[sCoin|$1]same[sCoin|$1]slot.[sCoin|$1]";
    _string += "\n\n[wave][sCoin|$3][sCoin|$3][sCoin|$3][sCoin|$3] [sSpriteFont]And they can be dynamically animated like other text too of course! [sCoin|$3][sCoin|$3][sCoin|$3][sCoin|$3]";

//Create a "scribble" data structure with a basic string
scribble = scribble_create( _string, -1, "default", fa_center );

//Set up animation speeds for each of the 4 sprite slots
scribble_set_sprite_slot_speed( scribble, 0, 0.05 );
scribble_set_sprite_slot_speed( scribble, 1, 0.13 );
scribble_set_sprite_slot_speed( scribble, 2, 0.01 );
scribble_set_sprite_slot_speed( scribble, 3, 0    ); //This slot has its image chosen randomly. Check the Step event for the code

//Align the scribble so that the draw coordinate is in the middle of the box
scribble_set_box_alignment( scribble, fa_center, fa_middle );

//Place the textbox to the middle of the room
x = room_width/2;
y = room_height/2;