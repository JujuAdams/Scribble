if (keyboard_check_pressed(vk_space))
{
    if (element.get_paused())
    {
        element.unpause();
    }
    else
    {
        if (element.get_state() == 0)
        {
            element.in(0.2, 10);
        }
        else if (element.get_state() == 1)
        {
            element.in(-0.2, 10);
        }
        else
        {
            element.skip();
        }
    }
}