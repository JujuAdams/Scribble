if (keyboard_check_pressed(vk_space))
{
    if (element.get_typewriter_state() == 1)
    {
        element.typewriter_out(0.3, 10, true);
        element.typewriter_ease(SCRIBBLE_EASE.BACK, 0, 30, 1, 1, 0, 0.3);
    }
    else if (element.get_typewriter_state() == 2)
    {
        element.typewriter_in(0.3, 10);
        element.typewriter_ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);
    }
}