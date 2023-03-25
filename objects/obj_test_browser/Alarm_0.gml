with(all)
{
    if (id == other.id) continue;
    instance_destroy();
}

index = (index + 1) mod array_length(object_array);
instance_create_depth(0, 0, 0, asset_get_index(object_array[index]));

alarm[0] = 10;