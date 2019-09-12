var _t = (current_time mod (500*13)) div 500;
draw_text(10, 10, _t);

//Set up the typewriter behaviour, using <show> as a toggle
scribble_set_typewriter(show, _t, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);

var _time = get_timer();

//Draw the text
scribble_draw(x - 150, y - 80, demo_string);

_time = get_timer() - _time;
timer_smoothed = lerp(timer_smoothed, _time, 0.01);

//Reset Scribble's state, like you would with any other draw function in GameMaker
scribble_state_reset();

draw_text(10, 30, timer_smoothed);