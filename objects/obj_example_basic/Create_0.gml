//Start up Scribble and load fonts automatically from Included Files
scribble_init("Fonts", "fnt_test_0", true);

//Add a spritefont to Scribble
//Scribble duplicates GameMaker's native spritefont rendering
//...but GM's spritefont renderer handles spaces weirdly so it's best to manually specify a width for Scribble
var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 3);