scribble_font_set_default("fnt_test_1");

scribble_default_preprocessor_set(function(_string)
{
    return "[c_yellow]" + _string;
});