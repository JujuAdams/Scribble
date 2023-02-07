function __scribble_asset_is_krutidev(_asset, _asset_type)
{
    var _tags_array = asset_get_tags(_asset, _asset_type);
    var _i = 0;
    repeat(array_length(_tags_array))
    {
        var _tag = _tags_array[_i];
        if ((_tag == "scribble krutidev") || (_tag == "Scribble krutidev") || (_tag == "Scribble Krutidev")) return true;
        ++_i;
    }
    
    return false;
}