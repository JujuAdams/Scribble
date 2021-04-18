/// The default template to use when creating a new Scribble text element
/// This is called automatically when a text element is created
/// You can reset a text element's formatting by specifying this function as the parameter for the .template() method

function __scribble_config_default_template()
{
    starting_format(SCRIBBLE_DEFAULT_FONT, c_white);
    align(fa_left, fa_top);
    blend(c_white, 1.0);
    transform(1, 1, 0); //No scaling or rotation
    origin(0, 0);
    wrap(-1, -1, false);
    line_height(-1, -1);
    page(0);
    fog(c_white, 0.0);
    ignore_command_tags(false);
    animation_wave(4, 50, 0.2);
    animation_shake(2, 0.4);
    animation_rainbow(0.5, 0.01);
    animation_wobble(40, 0.15);
    animation_pulse(0.4, 0.1);
    animation_wheel(1, 0.5, 0.2);
    animation_cycle(0.3, 180, 255);
    animation_jitter(0.8, 1.2, 0.4);
    
    if (!SCRIBBLE_WARNING_LEGACY_TYPEWRITER) typewriter_off();
}