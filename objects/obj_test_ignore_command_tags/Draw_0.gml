var _demo_string  = "[fa_center][fa_middle][rainbow][pulse]abcdef[/] [d$16711680]ABCDEF##";
    _demo_string += "[wave][c_orange]0123456789[/] .,<>\"'&[c_white][spr_coin,0][spr_coin,1][spr_coin,2][spr_coin,3][shake][rainbow]!?[/]\n";
    _demo_string += "[pin_centre][spr_coin][spr_coin][spr_coin][spr_large_coin][fa_left]\n";
    _demo_string += "[fa_left][outline_font]the quick brown fox [wave]jumps[/wave] over the [wheel]lazy[/wheel] dog";
    _demo_string += "[fnt_test_0][pin_right]THE [fnt_test_1][#ff4499][shake]QUICK[fnt_test_0] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fnt_test_1][wobble]DOG[/wobble].";

scribble(_demo_string)
.ignore_command_tags(mouse_check_button(mb_left))
.draw(room_width div 2, room_height div 2);