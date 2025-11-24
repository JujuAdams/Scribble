// Feather disable all

if (element.get_point_inside(350, 200, mouse_x, mouse_y))
{
    if (mouse_wheel_up())
    {
        element.scroll(element.get_scroll() - 6);
    }
    else if (mouse_wheel_down())
    {
        element.scroll(element.get_scroll() + 6);
    }
    
    if (keyboard_check_pressed(ord("1")))
    {
        element.scroll(element.__GetBlockY(0));
    }
    
    if (keyboard_check_pressed(ord("2")))
    {
        element.scroll(element.__GetBlockY(1));
    }
    
    if (keyboard_check_pressed(ord("3")))
    {
        element.scroll(element.__GetBlockY(3));
    }
}