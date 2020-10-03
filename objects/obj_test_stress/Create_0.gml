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
}

smoothed_time = 1000;