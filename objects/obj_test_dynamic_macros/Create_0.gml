scribble_font_set_default("fnt_test_2");

scribble_add_macro("macro a", function(_wave)
{
    if (_wave == "wave")
    {
        return $"[wave]{mouse_x}[/wave]";
    }
    else
    {
        return string(mouse_x);
    }
}, true);