//Start up Scribble and load fonts automatically from Included Files
scribble_init("Fonts", "fTestA", true);

//Add a spritefont to Scribble
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("sSpriteFont", _mapstring, 0, 3);

//Add some colour definitions
scribble_add_colour("c_coquelicot", $ff3800);
scribble_add_colour("c_smaragdine", $50c875);
scribble_add_colour("c_xanadu"    , $738678);
scribble_add_colour("c_amaranth"  , $e52b50);

//Some characters need a bit of fine adjustment in code since it's not always possible to fix this in the font itself
scribble_set_glyph_property("sSpriteFont", "f", SCRIBBLE_GLYPH.SEPARATION, -1, true);
scribble_set_glyph_property("sSpriteFont", "q", SCRIBBLE_GLYPH.SEPARATION, -1, true);



var _demo_string  = "[rainbow]abcdef[] ABCDEF##";
    _demo_string += "[wave][c_orange]0123456789[] .,<>\"'&[c_white][sCoin,0][sCoin,1][sCoin,2][sCoin,3][][shake][rainbow]!?[]\n";
    _demo_string += "[sCoin][sCoin,1,0.1][sCoin,2,0.1][sCoin,3,0.1]\n";
    _demo_string += "[sSpriteFont]the quick brown fox [wave]jumps[/wave] over the lazy dog";
    _demo_string += "[fTestA][fa_right]THE [fTestB][$FF4499][shake]QUICK[fTestA] [$D2691E]BROWN [$FF4499]FOX [fa_left]JUMPS OVER[$FFFF00] THE [/shake]LAZY [fTestB]DOG.";

//Set up the draw state. scribble_create() will inherit whatever draw state is currently being used
scribble_set_typewriter(true, 0.3, SCRIBBLE_TYPEWRITER_PER_CHARACTER, 3);
scribble_set_box_alignment(fa_center, fa_middle);

//Now parse the string to make some Scribble data
//We're using a cache group called "example cache group" to indicate we want to manage this memory ourselves
scribble_set_cache_group("example cache group", false);
scribble = scribble_draw(0, 0, _demo_string);

//Don't forget to reset the state!
scribble_state_reset();