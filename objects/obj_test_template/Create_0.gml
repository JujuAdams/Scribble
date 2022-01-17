template_test = method(undefined, function()
{
    starting_format("fnt_style", c_white);
    blend(c_red, 0.8);
});

template_other_test = method(undefined, function()
{
    show_debug_message("Should only appear once");
    
    starting_format("fnt_style", c_white);
    blend(c_lime, 1.0);
});