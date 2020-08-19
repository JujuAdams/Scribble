if (keyboard_check_pressed(vk_space))
{
    if (scribble_autotype_is_paused(text_element))
    {
        //If we're paused, unpause!
        scribble_autotype_set_pause(text_element, false);
    }
    else if (scribble_autotype_get(text_element) >= 1)
    {
        if (scribble_page_on_last(text_element))
        {
            //Increment our conversation index for the next piece of text
            textbox_conversation_index++;
            
            if (textbox_conversation_index >= array_length(textbox_conversation))
            {
                textbox_conversation_index = 0;
            }
            
            scribble_set_wrap(textbox_width, textbox_height);
            text_element = scribble_cache(textbox_conversation[textbox_conversation_index]);
            scribble_reset();
            scribble_page_set(text_element, 0);
            scribble_autotype_fade_in(text_element, 1, 0, false);
        }
        else
        {
            //Otherwise move to the next page
            scribble_page_set(text_element, 1 + scribble_page_get(text_element));
        }
    }
}