// Feather disable all

if (mouse_check_button(mb_left))
{
    scrollY += mouse_y - mousePrevY;
}

if (mouse_check_button(mb_middle))
{
    maxWidth  += mouse_x - mousePrevX;
    maxHeight += mouse_y - mousePrevY;
}

if (mouse_wheel_up())
{
    --serialPage;
}

if (mouse_wheel_down())
{
    ++serialPage;
}

mousePrevX = mouse_x;
mousePrevY = mouse_y;