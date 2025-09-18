// Feather disable all

if (mouse_check_button(mb_left))
{
    maxWidth  = mouse_x - 10;
    maxHeight = mouse_y - 10;
    
    element.max_size(maxWidth, maxHeight);
}

if (keyboard_check_pressed(vk_space))
{
    element.unpause();
}