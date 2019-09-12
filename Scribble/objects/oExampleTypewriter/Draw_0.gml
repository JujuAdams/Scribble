//Set up the typewriter behaviour, using <show> as a toggle
scribble_set_typewriter(show, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);

//Draw the text
scribble_draw(x - 150, y - 80, demo_string);

//Reset Scribble's state, like you would with any other draw function in GameMaker
scribble_state_reset();