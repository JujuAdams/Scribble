template_test = method(undefined, function()
{
    font(fnt_style);
    color(c_red);
    alpha(0);
});

template_other_test = method(undefined, function()
{
    show_debug_message("Should only appear once");
    
    font(fnt_style);
    color(c_lime);
    alpha(1);
});