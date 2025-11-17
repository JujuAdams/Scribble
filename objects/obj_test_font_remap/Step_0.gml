// Feather disable all

if (keyboard_check_pressed(ord("1")))
{
    scribble_font_set_remap("fnt_style", "fnt_style_i");
}

if (keyboard_check_pressed(ord("2")))
{
    scribble_font_set_remap("fnt_style", "fnt_style_b");
}

if (keyboard_check_pressed(ord("3")))
{
    scribble_font_set_remap("fnt_style", "fnt_style_bi");
}

if (keyboard_check_pressed(ord("0")))
{
    scribble_font_set_remap("fnt_style", undefined);
}