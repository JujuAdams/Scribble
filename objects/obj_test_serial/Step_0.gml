// Feather disable all

if (mouse_check_button(mb_left))
{
    var _element = scribble(text);
    _element.scroll(_element.get_scroll() + mouse_y - mousePrevY, false);
}

if (mouse_check_button(mb_middle))
{
    maxWidth  += mouse_x - mousePrevX;
    maxHeight += mouse_y - mousePrevY;
}

if (mouse_wheel_up())
{
    scribble(text).page(scribble(text).get_page() - 0.2);
}

if (mouse_wheel_down())
{
    scribble(text).page(scribble(text).get_page() + 0.2);
}

mousePrevX = mouse_x;
mousePrevY = mouse_y;