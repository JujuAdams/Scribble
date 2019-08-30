scribble_step(text);

//Swap between fading in and fading out
if (scribble_typewriter_get_state(text) == 1) scribble_typewriter_set_state(text, 1);
if (scribble_typewriter_get_state(text) == 2) scribble_typewriter_set_state(text, 0);