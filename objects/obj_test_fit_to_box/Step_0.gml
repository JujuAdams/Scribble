if (mouse_check_button(mb_left))
{
    width = mouse_x - x;
    height = mouse_y - y;
}

width += keyboard_check(vk_right) - keyboard_check(vk_left);
height += keyboard_check(vk_down) - keyboard_check(vk_up);