if (keyboard_check(ord("F")))
{
    if (is_struct(element))
    {
        element.flush();
        element = undefined;
    }
    
    gc_collect();
}