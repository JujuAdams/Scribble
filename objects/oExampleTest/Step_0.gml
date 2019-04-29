scribble_events_call(text);

if (scribble_typewriter_get_state(text) == 1) scribble_typewriter_out(text);
if (scribble_typewriter_get_state(text) == 2) scribble_typewriter_in(text);