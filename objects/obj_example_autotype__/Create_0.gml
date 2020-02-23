scribble_init("Fonts", "fnt_test_0", true);

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 3);

scribble_add_color("c_coquelicot", $ff3800);
scribble_add_color("c_smaragdine", $50c875);
scribble_add_color("c_xanadu"    , $738678);
scribble_add_color("c_amaranth"  , $e52b50);

scribble_autotype_add_event("test event", example_event);



var _demo_string  = "[rainbow][pulse]abcdef[] ABCDEF[test event]##";
    _demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][spr_coin,0][spr_coin,1][spr_coin,2][spr_coin,3][shake][rainbow]!?[]\n";
    _demo_string += "[fa_centre][spr_coin][spr_coin][spr_coin][spr_coin]\n";
    _demo_string += "[spr_sprite_font]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _demo_string += "[fnt_test_0][fa_right]THE [fnt_test_1][#ff4499][shake]QUICK[fnt_test_0] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fnt_test_1][wobble]DOG[/wobble].[test event][test event] [test event]";

element = scribble_draw(x - 150, y - 80, _demo_string);
scribble_autotype_fade_in(element, SCRIBBLE_AUTOTYPE_PER_CHARACTER, 0.5, 0);