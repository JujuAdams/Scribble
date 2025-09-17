// Feather disable all

function __ScribbleAssetIsKrutidev(_asset, _assetType)
{
    var _tags_array = asset_get_tags(_asset, _assetType);
    var _i = 0;
    repeat(array_length(_tags_array))
    {
        var _tag = _tags_array[_i];
        if ((_tag == "scribble krutidev") || (_tag == "Scribble krutidev") || (_tag == "Scribble Krutidev")) return true;
        ++_i;
    }
    
    return false;
}