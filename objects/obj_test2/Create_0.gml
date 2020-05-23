if (scribble_init("Fonts", "fnt_test_0", true))
{
    var _mapstring = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";
    scribble_add_spritefont("spr_sprite_font", _mapstring, 0, 11);
}

demo_string = "abcdefghijklm[pause]nopqrstuvwxyz";

element = scribble_draw(0, 0, demo_string);
scribble_autotype_fade_in(element, SCRIBBLE_AUTOTYPE_PER_CHARACTER, 0.1, 10);