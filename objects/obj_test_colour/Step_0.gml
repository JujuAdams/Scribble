if (keyboard_check_pressed(vk_space))
{
    switch(scribble_color_get("c_banana"))
    {
        case undefined: scribble_color_set("c_banana", #FAE7B5);   break;
        case #FAE7B5:   scribble_color_set("c_banana", #CD7F32);   break;
        case #CD7F32:   scribble_color_set("c_banana", undefined); break;
    }
}