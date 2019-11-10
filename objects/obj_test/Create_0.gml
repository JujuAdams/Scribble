scribble_init("Fonts", "fnt_test_0", true);
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 11);

scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

scribble_autotype_add_event("pause", example_pause);

scribble_set_glyph_property("spr_sprite_font", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("spr_sprite_font", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

//Native GM defintions
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
test_string = "The Quick Brown Fox Jumps Over The Lazy Dog!";
spritefont = font_add_sprite_ext(spr_sprite_font, _mapstring, true, 0);

demo_string  = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabcaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
demo_string += "[rainbow]TEST[] [slant]AaBbCcDdEeFf[/slant]##";
demo_string += "a b c d e f g h i j k l m n o p q r s t u v w x y z\n\n";
demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][spr_coin,0][spr_coin,1][spr_coin,2][spr_coin,3][][shake][rainbow]!?[]\n";
demo_string += "[spr_coin][spr_coin,1,0.1][spr_coin,2,0.1][spr_coin,3,0.1]    \n";
demo_string += "[spr_sprite_font]the quick brown fox [wave]jumps[/wave] over the lazy dog";
demo_string += "[fnt_test_0][fa_right]THE [fnt_test_1][#ff4499][shake]QUICK[fnt_test_0] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] [/shake]THE LAZY [fnt_test_1]DOG.";
demo_string += "##[fnt_test_2][c_black]TESTING";

//Now parse the string to make some Scribble data
//We're using a cache group called "example cache group" to indicate we want to manage this memory ourselves
scribble_draw_set_cache_group("example cache group", false, true);
scribble_draw_set_wrap(-1, 450, false);
element = scribble_draw(0, 0, demo_string);
scribble_autotype_fade_in(element, SCRIBBLE_AUTOTYPE_PER_CHARACTER, 2, 0);

//Don't forget to reset the state otherwise all subsequent Scribble text elements will inherit these settings
scribble_draw_reset();