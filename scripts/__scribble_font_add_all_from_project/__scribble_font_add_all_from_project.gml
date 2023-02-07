function __scribble_font_add_all_from_project()
{
    //Try to add all fonts in the project to Scribble
    var _i = 0;
    repeat(1000)
    {
        if (!font_exists(_i)) break;
        
        var _skip = false;
        
        var _tags = asset_get_tags(_i, asset_font);
        var _j = 0;
        repeat(array_length(_tags))
        {
            if (string_lower(_tags[_j]) == "scribble skip")
            {
                _skip = true;
                break;
            }
            
            ++_j;
        }
        
        //Don't scan fonts created at runtime (e.g. by font_add_sprite())
        var _name = font_get_name(_i);
        if (string_copy(_name, 1, 9) == "__newfont") _skip = true;
        
        if (!_skip)
        {
            __scribble_font_add_from_project(_i);
        }
    
        ++_i;
    }
    
    //Find every sprite asset with the "scribble sdf" tag
    //We check variations on the tag because they're case sensitive and people might spell it differently despite what documentation says
    var _assets = [];
    
    var _array = tag_get_assets("Scribble SDF");
    array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));
    
    var _array = tag_get_assets("scribble SDF");
    array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));
    
    var _array = tag_get_assets("Scribble sdf");
    array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));
    
    var _array = tag_get_assets("scribble sdf");
    array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));
    
    var _array = tag_get_assets("scribblesdf");
    array_copy(_assets, array_length(_assets), _array, 0, array_length(_array));
    
    var _i = 0;
    repeat(array_length(_assets))
    {
        var _asset = _assets[_i];
        if (asset_get_type(_asset) != asset_sprite)
        {
            __scribble_error("\"scribble sdf\" tag should only be applied to sprite assets (\"", _asset, "\" had the tag)");
        }
        else
        {
            __scribble_font_add_sdf_from_project(asset_get_index(_asset));
        }
        
        ++_i;
    }
}