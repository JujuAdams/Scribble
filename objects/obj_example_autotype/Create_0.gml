//Start up Scribble and load fonts automatically from Included Files
if (scribble_init("Fonts", "fnt_test_0", true))
{
    //Add a spritefont to Scribble
    var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
    scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 3);
    
    //Add some colour definitions that we'll use in the demo string
    scribble_add_color("c_coquelicot", $ff3800);
    scribble_add_color("c_smaragdine", $50c875);
    scribble_add_color("c_xanadu"    , $738678);
    scribble_add_color("c_amaranth"  , $e52b50);
    
    scribble_add_autotype_event("test event", example_event);
}



//Define a demo string for use in the Draw event
var _demo_string  = "[rainbow][pulse]abcdef[] ABCDEF[test event]##";
    _demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][spr_coin,0][spr_coin,1][spr_coin,2][spr_coin,3][shake][rainbow]!?[]\n";
    _demo_string += "[pin_centre][spr_coin][spr_coin][spr_coin][spr_large_coin][test event]\n";
    _demo_string += "[pin_left][spr_sprite_font]the quick[delay] brown[delay] fox[delay] [wave]jumps[/wave] over the lazy dog\n";
    _demo_string += "Press any key to continue[pause]\n";
    _demo_string += "[fnt_test_0][pin_right]THE [fnt_test_1][#ff4499][shake]QUICK[fnt_test_0] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fnt_test_1][wobble]DOG[/wobble].";

element = scribble_cache(_demo_string);
scribble_autotype_fade_in(element, 0.5, 10, false);
//scribble_autotype_function(element, example_autotype_callback);
scribble_autotype_set_sound(element, [snd_vowel_0, snd_vowel_1, snd_vowel_2, snd_vowel_3, snd_vowel_4], 30, 0.9, 1.1);