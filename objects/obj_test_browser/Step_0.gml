if (keyboard_check_pressed(219)) // [
{
    with(all)
    {
        if (id == other.id) continue;
        instance_destroy();
    }
    
    index = (index - 1 + array_length(object_array)) mod array_length(object_array);
    instance_create_depth(0, 0, 0, asset_get_index(object_array[index]));
}

if (keyboard_check_pressed(221)) // ]
{
    with(all)
    {
        if (id == other.id) continue;
        instance_destroy();
    }
    
    index = (index + 1) mod array_length(object_array);
    instance_create_depth(0, 0, 0, asset_get_index(object_array[index]));
}