//Start up Scribble and load fonts automatically from Included Files
scribble_init("Fonts", "fnt_test_0", true);

//Add a spritefont to Scribble
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 3);

//Add some colour definitions
scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

//Some characters need a bit of fine adjustment in code since it's not always possible to fix this in the font itself
scribble_set_glyph_property("spr_sprite_font", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("spr_sprite_font", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);

scribble_autotype_add_event("sound", example_event_sound);



var _demo_string  = "[sound,snd_crank][rainbow]abcdef[] ABCDEF##";
    _demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][spr_coin,0][sound,snd_switch][spr_coin,1][sound,snd_switch][spr_coin,2][sound,snd_switch][spr_coin,3][sound,snd_switch][][shake][rainbow]!?[]\n";
    _demo_string += "[spr_coin][spr_coin,1,0.1][spr_coin,2,0.1][spr_coin,3,0.1]\n";
    _demo_string += "[spr_sprite_font]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _demo_string += "[fnt_test_0][fa_right]THE [fnt_test_1][$FF4499][shake]QUICK[fnt_test_0] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fnt_test_1]DOG.";

//Set up the draw state
//If you're pre-caching text elements, scribble_draw() will inherit whatever draw state is currently being used
scribble_draw_set_fade(true, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);
scribble_draw_set_box_align(fa_center, fa_middle);

//Now parse the string to make some Scribble data
//We're using a cache group called "example cache group" to indicate we want to manage this memory ourselves
scribble_draw_set_cache_group("example cache group", false, true);
element = scribble_draw(0, 0, _demo_string);
scribble_autotype_set(element, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 0.3, 0, true);

//Don't forget to reset the state!
scribble_draw_reset();