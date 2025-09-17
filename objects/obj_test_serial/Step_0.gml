// Feather disable all

if (mouse_check_button(mb_left))
{
    var _element = scribble(text);
    _element.scroll(_element.get_scroll_y() + mouse_y - mousePrevY, false);
}

if (mouse_check_button(mb_middle))
{
    maxWidth  += mouse_x - mousePrevX;
    maxHeight += mouse_y - mousePrevY;
}

if (keyboard_check_pressed(vk_left))
{
    scribble(text).previous_page();
}

if (keyboard_check_pressed(vk_right))
{
    scribble(text).next_page();
}

mousePrevX = mouse_x;
mousePrevY = mouse_y;