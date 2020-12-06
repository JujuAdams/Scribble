if (keyboard_check_pressed(vk_space))
{
    if (scribble_autotype_is_paused(element))
    {
        //If we're paused, unpause!
        scribble_autotype_set_pause(element, false);
    }
    else if (scribble_autotype_get(element) < 1)
    {
        //If we haven't finised yet, skip to the end of this page
        scribble_autotype_skip(element);
    }
    else if (scribble_page_on_last(element))
    {
        //Loop back round to the first page if we've reached the end
        scribble_page_set(element, 0);
    }
    else
    {
        //Otherwise move to the next page
        scribble_page_set(element, 1 + scribble_page_get(element));
    }
}