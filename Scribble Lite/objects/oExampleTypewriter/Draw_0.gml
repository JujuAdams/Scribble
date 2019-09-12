//Set up the typewriter behaviour, using <show> as a toggle
scribble_set_typewriter(show, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);

var _t = get_timer();

//Draw the text
scribble_draw(x - 150, y - 80, demo_string);

_t = get_timer() - _t;
timer_smoothed = lerp(timer_smoothed, _t, 0.01);

//Reset Scribble's state, like you would with any other draw function in GameMaker
scribble_state_reset();

draw_text(10, 10, timer_smoothed);