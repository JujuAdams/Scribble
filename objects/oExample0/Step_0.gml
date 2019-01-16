//Update the sprite animations
scribble_step( scribble );

//Randomly choose a new image for sprite in slot 3
if ( random(1) < 0.05 ) scribble_set_sprite_slot_image( scribble, 3, irandom( sprite_get_number(sCoin)-1 ) );

line_pos = min( line_pos + 0.07, scribble_get_lines( scribble ) );
scribble_set_line_fade_in( scribble, line_pos, 3 );