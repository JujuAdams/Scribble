if (keyboard_check_pressed(vk_space))
{
    if (text_element.get_typewriter_paused())
    {
        //If we're paused, unpause!
        text_element.typewriter_unpause(false);
    }
    else if (text_element.get_typewriter_state() >= 1)
    {
        if (text_element.get_page() >= text_element.get_pages())
        {
            //Increment our conversation index for the next piece of text
            textbox_conversation_index++;
            
            if (textbox_conversation_index >= array_length(textbox_conversation))
            {
                textbox_conversation_index = 0;
            }
            
            text_element = scribble(textbox_conversation[textbox_conversation_index])
                          .wrap(textbox_width, textbox_height)
                          .typewriter_in(1, 0, false)
                          .cache_now(true);
        }
        else
        {
            //Otherwise move to the next page
            text_element.page(text_element.get_page() + 1);
        }
    }
}