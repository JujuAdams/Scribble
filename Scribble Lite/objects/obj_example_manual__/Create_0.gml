//Setup
scribble_init("Fonts", "fTestA", true);

var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("sSpriteFont", _mapstring, 0, 3);

scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

scribble_set_glyph_property("sSpriteFont", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("sSpriteFont", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);



//Create the text element
var _demo_string  = "[rainbow]abcdef[] ABCDEF##";
    _demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sCoin,1][sCoin,2][sCoin,3][][shake][rainbow]!?[]\n";
    _demo_string += "[sCoin][sCoin,1,0.1][sCoin,2,0.1][sCoin,3,0.1]\n";
    _demo_string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _demo_string += "[fTestA][fa_right]THE [fTestB][$FF4499][shake]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fTestB]DOG.";

scribble_draw_set_fade(true, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);
scribble_draw_set_box_align(fa_center, fa_middle);
scribble_draw_set_cache_group("example cache group", false, false);
scribble = scribble_draw(0, 0, _demo_string);
scribble_draw_reset();