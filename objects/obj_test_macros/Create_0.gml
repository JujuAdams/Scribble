scribble_font_set_default("fnt_test_2");

scribble_add_macro("macro a", function(_wave)
{
    if (_wave == "wave")
    {
        return "[wave]hello![/wave]";
    }
    else
    {
        return "hello!";
    }
});