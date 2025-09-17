// Feather disable all

if (mouse_check_button(mb_left))
{
    serialY += mouse_y - mousePrevY;
}

if (mouse_check_button(mb_middle))
{
    maxWidth  += mouse_x - mousePrevX;
    maxHeight += mouse_y - mousePrevY;
}

if (mouse_check_button(mb_right))
{
    scrollY += mouse_y - mousePrevY;
}

if (mouse_wheel_up())
{
    serialY += 5;
}

if (mouse_wheel_down())
{
    serialY -= 5;
}

mousePrevX = mouse_x;
mousePrevY = mouse_y;