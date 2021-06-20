if (keyboard_check_pressed(vk_space))
{
    if (element1.get_typewriter_state() == 1)
    {
        element1.typewriter_out(0.3, 10, true);
        element1.typewriter_ease(SCRIBBLE_EASE.BACK, 0, 30, 1, 1, 0, 0.3);
    }
    else if (element1.get_typewriter_state() == 2)
    {
        element1.typewriter_in(0.3, 10);
        element1.typewriter_ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);
    }
    
    if (element2.get_typewriter_state() == 1)
    {
        element2.typewriter_out(0.3, 10, true);
        element2.typewriter_ease(SCRIBBLE_EASE.BACK, 0, 30, 1, 1, 0, 0.3);
    }
    else if (element2.get_typewriter_state() == 2)
    {
        element2.typewriter_in(0.3, 10);
        element2.typewriter_ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);
    }
}