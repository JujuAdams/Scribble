var _demo_string  = "Here's some text with [cycle,test]custom colour[/cycle] cycling!\n";
    _demo_string += "And here's [rainbow]rainbow text[/rainbow] for comparison\n";
    _demo_string += "[cycle,test][spr_white_coin,0][spr_white_coin,1][spr_white_coin,2] cycle [spr_white_coin,0,0.1][spr_white_coin,1,0.1][spr_white_coin,2,0.1][spr_white_coin,1,0.1][/cycle] no cycle";

scribble(_demo_string).draw(x, y);