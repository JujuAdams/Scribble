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
            element.typist_ease(SCRIBBLE_EASE.BACK, 0, 30, 1, 1, 0, 0.3);
        }
        else if (typist.get_state() == 2)
        {
            element.in(0.3, 10);
            element.typist_ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);
        }
        else
        {
            element.skip();
        }
    }
}