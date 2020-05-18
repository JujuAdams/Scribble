//Start up Scribble and load fonts automatically from Included Files
if (scribble_init("Fonts", "fnt_test_0", true))
{
    //Add a spritefont to Scribble
    var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
    scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 3);
    
    //Add some colour definitions
    scribble_add_color("c_coquelicot", $ff3800);
    scribble_add_color("c_smaragdine", $50c875);
    scribble_add_color("c_xanadu"    , $738678);
    scribble_add_color("c_amaranth"  , $e52b50);
    
    //Some characters need a bit of fine adjustment in code since it's not always possible to fix this in the font itself
    scribble_set_glyph_property("spr_sprite_font", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
    scribble_set_glyph_property("spr_sprite_font", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);
    
    scribble_add_autotype_event("sound", example_event_sound);
}



var _demo_string  = "[sound,snd_crank][rainbow][pulse]abcdef[] ABCDEF##";
    _demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][spr_coin,0][sound,snd_switch][spr_coin,1][sound,snd_switch][spr_coin,2][sound,snd_switch][spr_coin,3][sound,snd_switch][][shake][rainbow]!?[]\n";
    _demo_string += "[fa_center][spr_coin][spr_coin,1,0.1][spr_coin,2,0.1][spr_large_coin,3,0.1][]\n";
    _demo_string += "[fa_left][spr_sprite_font]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _demo_string += "[fnt_test_0][fa_right]THE [fnt_test_1][#ff4499][shake]QUICK[fnt_test_0] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fnt_test_1][wobble]DOG[/wobble].";

//Now parse the string to make some Scribble data
//We're using a cache group called "example cache group" to indicate we want to manage this memory ourselves
element = scribble_cache(_demo_string, "example cache group");

//Don't forget to reset the state otherwise all subsequent Scribble text elements will inherit these settings
scribble_draw_reset();