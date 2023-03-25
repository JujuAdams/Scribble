if (mouse_check_button(mb_left))
{
    width  = mouse_x - x;
    height = mouse_y - y;
}

if (keyboard_check_pressed(vk_up)) page++;
if (keyboard_check_pressed(vk_down)) page--;