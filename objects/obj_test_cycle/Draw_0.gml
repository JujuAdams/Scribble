var _demo_string  = "Here's some text with [cycle,40,90,150,190]custom colour[/cycle] cycling!\n";
    _demo_string += "And here's [rainbow]rainbow text[/rainbow] for comparison\n";
    _demo_string += "[cycle,40,90,150,190][spr_white_coin,0][spr_white_coin,1][spr_white_coin,2] cycle [spr_white_coin,0,0.1][spr_white_coin,1,0.1][spr_white_coin,2,0.1][spr_white_coin,1,0.1][/cycle] no cycle";

scribble_set_animation(SCRIBBLE_ANIM.CYCLE_SPEED     , 0.2);
scribble_set_animation(SCRIBBLE_ANIM.CYCLE_SATURATION, 255);
scribble_draw(x, y, _demo_string);
scribble_reset();