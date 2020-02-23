if (keyboard_check_pressed(vk_space))
{
    if (scribble_autotype_get(element) < 1)
    {
        scribble_autotype_skip(element);
    }
    else if (!scribble_page_on_last(element))
    {
        scribble_page_set(element, 1 + scribble_page_get(element));
        scribble_autotype_fade_in(element, SCRIBBLE_AUTOTYPE_PER_CHARACTER, 1, 10);
    }
    else
    {
        scribble_page_set(element, 0);
        scribble_autotype_fade_in(element, SCRIBBLE_AUTOTYPE_PER_CHARACTER, 1, 10);
    }
}