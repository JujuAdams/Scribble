scribble_set_animation(SCRIBBLE_ANIM.CYCLE_WEIGHT, 0.8); //80% opacity
scribble_set_animation(SCRIBBLE_ANIM.CYCLE_HUES_ABC, (170 << 16) | (180 << 8) | (150)); //lol
scribble_set_animation(SCRIBBLE_ANIM.CYCLE_HUES_DEF, (150 << 16) | (170 << 8) | (170));

var _demo_string  = "Here's some text with [cycle]colour[/cycle] cycling!\n";
    _demo_string += "And here's [rainbow]rainbow text[/rainbow] for comparison";

//Draw the string
scribble_draw(x - 150, y - 80, _demo_string);