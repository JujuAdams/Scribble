var _demo_string  = "Here's some text with [cycle,40,90,150,190]custom colour[/cycle] cycling!\n";
    _demo_string += "And here's [rainbow]rainbow text[/rainbow] for comparison";

scribble_set_animation(SCRIBBLE_ANIM.CYCLE_SPEED     , 0.2);
scribble_set_animation(SCRIBBLE_ANIM.CYCLE_SATURATION, 255);
scribble_draw(x - 150, y - 80, _demo_string);
scribble_reset();