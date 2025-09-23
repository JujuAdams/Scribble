if (keyboard_check_pressed(vk_space))
{
    if (element.typist_get_paused())
    {
        element.typist_unpause();
    }
    else
    {
        if (element.typist_get_finished())
        {
            if (element.typist_get_options().appear)
            {
                element.typist_options({ appear: false, speed: 0.3, smoothness: 10 });
                element.typist_ease(SCRIBBLE_EASE_BACK, 0, 30, 1, 1, 0, 0.3);
            }
            else
            {
                element.typist_options({ appear: true, speed: 0.3, smoothness: 10 });
                element.typist_ease(SCRIBBLE_EASE_BOUNCE, 0, -40, 1, 1, 0, 0.1);
            }
        }
    }
}