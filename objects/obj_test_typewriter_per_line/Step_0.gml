if (keyboard_check_pressed(vk_space))
{
    if (element.get_paused())
    {
        element.unpause();
    }
    else
    {
        if (element.get_state() == 1)
        {
            element.out(0.3, 10, true);
            element.ease(SCRIBBLE_EASE_BACK, 0, 30, 1, 1, 0, 0.3);
        }
        else if (element.get_state() == 2)
        {
            element.in(0.3, 10);
            element.ease(SCRIBBLE_EASE_BOUNCE, 0, -40, 1, 1, 0, 0.1);
        }
    }
}