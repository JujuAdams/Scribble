object_array = tag_get_asset_ids("test cases", asset_object);
array_sort(object_array, true);

index = undefined;
var _i = 0;
repeat(array_length(object_array))
{
    if (instance_exists(object_array[_i]))
    {
        index = _i;
        break;
    }
    
    ++_i;
}

if (index == undefined)
{
    index = 0;
    instance_create_depth(0, 0, 0, object_array[index]);
}