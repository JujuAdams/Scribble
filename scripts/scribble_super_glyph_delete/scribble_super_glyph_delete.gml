// Feather disable all
function scribble_super_glyph_delete(_target)
{
    static _fontDataMap = __ScribbleSystem().__fontDataMap;
    var _fontData = _fontDataMap[? _target];
    if (_fontData == undefined) __ScribbleError("Font \"", _fontData, "\" not found");
    
    var _glyphs_map = _fontData.__glyphsMap;
    
    //Copy arguments into an array
    var _glyphsArray = array_create(argument_count - 1);
    var _i = 0;
    repeat(argument_count - 1)
    {
        _glyphsArray[@ _i] = argument[_i+1];
        ++_i;
    }
    
    //Pass the argument array into our preparation function
    //This turns the argument array in a series of ranges to operate on
    var _workArray = __ScribblePrepareSuperWorkArray(_glyphsArray);
    
    var _i = 0;
    repeat(array_length(_workArray))
    {
        var _glyphRangeArray = _workArray[_i];
        
        var _unicode = _glyphRangeArray[0];
        repeat(1 + _glyphRangeArray[1] - _unicode)
        {
            ds_map_delete(_glyphs_map, _unicode);
            ++_unicode;
        }
        
        ++_i;
    }
}
