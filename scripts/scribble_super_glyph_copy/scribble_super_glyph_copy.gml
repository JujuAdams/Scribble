// Feather disable all
/// @param target
/// @param source
/// @param overwrite
/// @param glyphs
/// @param [glyphs]...

function scribble_super_glyph_copy(_target, _source, _overwrite)
{
    var _targetFontData = __ScribbleGetFontData(_target);
    var _sourceFontData = __ScribbleGetFontData(_source);
    
    var _targetGlyphsMap      = _targetFontData.__glyphsMap;
    var _targetGlyphsDataGrid = _targetFontData.__glyphDataGrid;
    var _sourceGlyphsMap      = _sourceFontData.__glyphsMap;
    var _sourceGlyphsDataGrid = _sourceFontData.__glyphDataGrid;
    
    //Copy arguments into an array
    var _glyphsArray = array_create(argument_count - 3);
    var _i = 0;
    repeat(argument_count - 3)
    {
        _glyphsArray[@ _i] = argument[_i+3];
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
            __ScribbleGlyphDuplicate(_sourceGlyphsMap, _sourceGlyphsDataGrid, _targetGlyphsMap, _targetGlyphsDataGrid, _unicode, _overwrite);
            ++_unicode;
        }
        
        ++_i;
    }
    
    //Choose maximal values
    _targetFontData.__height     = max(_targetFontData.__height,     _sourceFontData.__height);
    _targetFontData.__underlineY = max(_targetFontData.__underlineY, _sourceFontData.__underlineY);
    _targetFontData.__strikeY    = max(_targetFontData.__strikeY,    _sourceFontData.__strikeY);
    
    ds_grid_set_region(_targetGlyphsDataGrid, 0, __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT, ds_grid_width(_targetGlyphsDataGrid), __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT, _targetFontData.__height);
}

function __ScribblePrepareSuperWorkArray(_input_array)
{
    var _outputArray = [];
    
    var _i = 0;
    repeat(array_length(_input_array))
    {
        var _glyphToCopy = _input_array[_i];
        
        if (is_string(_glyphToCopy))
        {
            var _j = 1;
            repeat(string_length(_glyphToCopy))
            {
                //TODO - Make this more efficient by grouping contiguous glyphs together
                var _unicode = ord(string_char_at(_glyphToCopy, _j));
                array_push(_outputArray, [_unicode, _unicode]);
                ++_j;
            }
            
            _glyphToCopy = undefined;
        }
        
        if (is_numeric(_glyphToCopy))
        {
            _glyphToCopy = [_glyphToCopy, _glyphToCopy];
        }
        
        if (is_array(_glyphToCopy))
        {
            array_push(_outputArray, _glyphToCopy);
        }
        
        ++_i;
    }
    
    return _outputArray;
}

function __ScribbleGlyphDuplicate(_sourceMap, _sourceGrid, _targetMap, _targetGrid, _glyph, _overwrite)
{
    var _sourceX = _sourceMap[? _glyph];
    if (_sourceX == undefined)
    {
        __ScribbleTrace("Warning! Glyph ", _glyph, " (", chr(_glyph), ") not found in source font");
        return;
    }
    
    var _targetX = _targetMap[? _glyph];
    if (_targetX == undefined)
    {
        //Create a new column in the grid to store this glyph's data
        var _targetX = ds_grid_width(_targetGrid);
        _targetMap[? _glyph] = _targetX;
        ds_grid_resize(_targetGrid, _targetX+1, __SCRIBBLE_GLYPH_PROPR_SIZE);
    }
    else
    {
        if (not _overwrite)
        {
            //Glyph already exists in target, skip it
            return;
        }
        
        //Copy data from source directly into the existing slot in the font's glyph table
    }
    
    //Do the actual copying
    ds_grid_set_grid_region(_targetGrid, _sourceGrid, _sourceX, 0, _sourceX, __SCRIBBLE_GLYPH_PROPR_SIZE, _targetX, 0);
}
