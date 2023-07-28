// Feather disable all
#macro __SCRIBBLE_PARSER_INSERT_NUKTA  ds_grid_set_grid_region(_temp_grid, _glyph_grid, _i+1, 0, _glyph_count+3, __SCRIBBLE_GEN_GLYPH.__SIZE, 0, 0);\
                                       ds_grid_set_grid_region(_glyph_grid, _temp_grid, 0, 0, _glyph_count+3 - _i, __SCRIBBLE_GEN_GLYPH.__SIZE, _i+2, 0);\
                                       ;\
                                       ++_i;\
                                       ++_glyph_count;\
                                       ;\
                                       _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x093C;\ //Nukta
                                       _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];


function __scribble_gen_3_devanagari()
{
    //Avoid this mess if we can
    if (!__has_devanagari) exit;
    
    static _krutidev_lookup_map       = __scribble_get_krutidev_lookup_map();
    static _krutidev_matra_lookup_map = __scribble_get_krutidev_matra_lookup_map();
    
    static _generator_state = __scribble_get_generator_state();
    with(_generator_state)
    {
        var _glyph_grid   = __glyph_grid;
        var _control_grid = __control_grid;
        var _temp_grid    = __temp2_grid;
        var _glyph_count = _generator_state.__glyph_count;
    }
    
    //Glyph count includes the terminating null. We don't need that for Krutidev conversion
    --_glyph_count;
    
    //Pad the end because we'll need to read beyond the end of the string during the final find-replace
    //We pad with 0xFFFF to avoid accidentally making incorrect substring matches later
    _glyph_grid[# _glyph_count,   __SCRIBBLE_GEN_GLYPH.__UNICODE] = 0xFFFF;
    _glyph_grid[# _glyph_count+1, __SCRIBBLE_GEN_GLYPH.__UNICODE] = 0xFFFF;
    _glyph_grid[# _glyph_count+2, __SCRIBBLE_GEN_GLYPH.__UNICODE] = 0xFFFF;
    _glyph_grid[# _glyph_count+3, __SCRIBBLE_GEN_GLYPH.__UNICODE] = 0xFFFF;
    
    
    
    #region Transform quotes and split up nukta ligatures
    
    var _in_single_quote = false;
    var _in_double_quote = false;
    var _i = 0;
    repeat(_glyph_count)
    {
        switch(_glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE])
        {
            //Set up alternating single quote marks
            case ord("'"):
                _in_single_quote = !_in_single_quote;
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = __SCRIBBLE_DEVANAGARI_OFFSET + (_in_single_quote? ord("^") : ord("*"));
            break;
            
            //Set up alternating double quote marks
            case ord("\""):
                _in_double_quote = !_in_double_quote;
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = __SCRIBBLE_DEVANAGARI_OFFSET + (_in_double_quote? ord("ß") : ord("Þ"));
            break;
            
            //Split up nukta ligatures into their componant parts
            //TODO - Convert to hex and add comments
            case ord("ऩ"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("न");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ऱ"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("र");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("क़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("क");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ख़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ख");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ग़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ग");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ज़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ज");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ड़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ड");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("ढ़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("ढ");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("फ़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("फ");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
            
            case ord("य़"):
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = ord("य");
                __SCRIBBLE_PARSER_INSERT_NUKTA
            break;
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Reposition ि  to the front of the word and replace it with an "f"
    
    //TODO - Log where ि  is found during the nukta ligature sweep
    var _i = 1; //Start at the second char because we don't care if the string starts with 0x093F (Vowel Sign I)
    repeat(_glyph_count-1)
    {
        var _char = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE];
        if (_char == ord("ि"))
        {
            var _j = _i - 1;
            while(_j >= 0)
            {
                var _prev_char = _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__UNICODE];
                if (_prev_char == 0x094D)
                {
                    //If we find a virama behind us keep tracking backwards
                    //We go two indexes backwards because virama (should) always follows another character
                    _j -= 2;
                }
                else if (_prev_char == 0x093C) 
                {
                    //Move behind a nukta too
                    _j -= 1;
                }
                else
                {
                    break;
                }
            }
            
            //Copy everything from the start of the subtring (where ि  will go) to the end (which is where ि  currently is)
            ds_grid_set_grid_region(_temp_grid, _glyph_grid, _j, 0, _i-1, __SCRIBBLE_GEN_GLYPH.__SIZE, 0, 0);
            
            //Then copy that back into the glyph grid, but one character forwards
            ds_grid_set_grid_region(_glyph_grid, _temp_grid, 0, 0, _i-1 - _j, __SCRIBBLE_GEN_GLYPH.__SIZE, _j+1, 0);
            
            //Insert ि  (encoded in Krutidev as f) into its new position
            _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = __SCRIBBLE_DEVANAGARI_OFFSET + ord("f");
            _glyph_grid[# _j, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _j+1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Move र् (ra + virama) after matras
    
    //Using a for-loop here as _glyph_count may change
    for(var _i = 0; _i < _glyph_count; ++_i)
    {
        //TODO - Log where ra-virama is found during the nukta ligature sweep
        if ((_glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] == ord("र")) && (_glyph_grid[# _i+1, __SCRIBBLE_GEN_GLYPH.__UNICODE] == 0x094D)) //Ra followed by virama
        {
            var _newPosition = _i + 2;
            
            //If the character after the probable position for ra+virama is a matra, keep searching right
            var _charRight = _glyph_grid[# _newPosition+1, __SCRIBBLE_GEN_GLYPH.__UNICODE];
            while(ds_map_exists(_krutidev_matra_lookup_map, _charRight))
            {
                _newPosition++;
                _charRight = _glyph_grid[# _newPosition+1, __SCRIBBLE_GEN_GLYPH.__UNICODE];
            }
            
            var _copyCount = 1 + _newPosition - (_i+2)
            
            //Copy everything after the ra-virama position into the temp buffer
            //We're going to copy that back into the glyph grid in two stages
            ds_grid_set_grid_region(_temp_grid, _glyph_grid, _i+2, 0, _glyph_count-1 + 4, __SCRIBBLE_GEN_GLYPH.__SIZE, _i+2, 0);
            
            //First copy: Move the gylphs between the old position and the new position back two slots
            //            This effective deletes the old ra+virama position
            ds_grid_set_grid_region(_glyph_grid, _temp_grid, _i+2, 0, _newPosition, __SCRIBBLE_GEN_GLYPH.__SIZE, _i, 0);
            
            //Insert the new ra+virama combined character. Krutidev handles this as a single glyph (encoded as Z)
            _glyph_grid[# _i + _copyCount, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = __SCRIBBLE_DEVANAGARI_OFFSET + ord("Z");
            _glyph_grid[# _i + _copyCount, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _copyCount-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];
            
            //Second copy: Place the remainder of the glyphs after ra+virama
            ds_grid_set_grid_region(_glyph_grid, _temp_grid, _newPosition+1, 0, _glyph_count+3, __SCRIBBLE_GEN_GLYPH.__SIZE, _i + _copyCount + 1, 0);
            
            //Overall this reduces the total number of glyphs by one since we're replace ra + virama with a single Z
            --_glyph_count;
        }
    }
    
    #endregion
    
    
    
    #region Perform bulk find-replace
    
    //Create a 64-bit minibuffer
    //Fortunately all the characters we're looking for fit into 16 bits and we only need to look for 4 at a time
    var _oneChar   = 0x0000;
    var _twoChar   =              ((_glyph_grid[# 0, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 16);
    var _threeChar = _twoChar   | ((_glyph_grid[# 1, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 32);
    var _fourChar  = _threeChar | ((_glyph_grid[# 2, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 48);
    
    //Using a for-loop here as _glyph_count may change
    for(var _i = 0; _i < _glyph_count; ++_i;)
    {
        _oneChar   = _twoChar   >> 16;
        _twoChar   = _threeChar >> 16;
        _threeChar = (_fourChar & 0x7FFFFFFFFFFFFFFF) >> 16; //Ensure the top bit is 0 so we get zeroes across the LHS
        _fourChar  = _threeChar | ((_glyph_grid[# _i+3, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 48);
        
        //Try to find a matching substring
        var _foundLength = 4;
        var _replacementArray = _krutidev_lookup_map[? _fourChar];
        
        if (_replacementArray == undefined)
        {
            _foundLength = 3;
            _replacementArray = _krutidev_lookup_map[? _threeChar];
            
            if (_replacementArray == undefined)
            {
                _foundLength = 2;
                _replacementArray = _krutidev_lookup_map[? _twoChar];
                
                if (_replacementArray == undefined)
                {
                    _foundLength = 1;
                    _replacementArray = _krutidev_lookup_map[? _oneChar];
                }
            }
        }
        
        //Perform a character replacement if we found any matching substring
        if (_replacementArray != undefined)
        {
            var _replacementLength = array_length(_replacementArray);
            
            if ((_foundLength == 1) && (_replacementLength == 1))
            {
                //Shortcut for the most common replacement operation
                _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE] = __SCRIBBLE_DEVANAGARI_OFFSET + _replacementArray[0];
            }
            else
            {
                //Heavyweight general replacement code... we want to avoid as many delete/insert commands as possible
                
                //Overwrite as much data as possible. This reduces ds_grid_set_grid_region() calls
                var _copyCount = min(_foundLength, _replacementLength);
                var _j = 0;
                repeat(_copyCount)
                {
                    _glyph_grid[# _i + _j, __SCRIBBLE_GEN_GLYPH.__UNICODE] = __SCRIBBLE_DEVANAGARI_OFFSET + _replacementArray[_j];
                    ++_j;
                }
                
                if (_foundLength > _replacementLength)
                {
                    //If we're replacing with fewer characters than we found then we need to delete some characters
                    var _copyStart = _i + _copyCount + _foundLength - _replacementLength;
                    var _copyLength = _glyph_count - _copyStart;
                    
                    ds_grid_set_grid_region(_temp_grid, _glyph_grid, _copyStart, 0, _glyph_count, __SCRIBBLE_GEN_GLYPH.__SIZE, 0, 0);
                    ds_grid_set_grid_region(_glyph_grid, _temp_grid, 0, 0, _copyLength, __SCRIBBLE_GEN_GLYPH.__SIZE, _i + _copyCount, 0);
                }
                else if (_foundLength < _replacementLength)
                {
                    //Otherwise, we're adding characters to the array so we have to insert some characters into the output grid
                    
                    var _insertPos = _i + _copyCount;
                    ds_grid_set_grid_region(_temp_grid, _glyph_grid, _insertPos, 0, _glyph_count, __SCRIBBLE_GEN_GLYPH.__SIZE, 0, 0);
                    ds_grid_set_grid_region(_glyph_grid, _temp_grid, 0, 0, _glyph_count - _insertPos, __SCRIBBLE_GEN_GLYPH.__SIZE, _insertPos + (_replacementLength - _foundLength), 0);
                    
                    if (_replacementLength - _foundLength == 1)
                    {
                        //Adding one character
                        _glyph_grid[# _insertPos, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = __SCRIBBLE_DEVANAGARI_OFFSET + _replacementArray[_replacementLength-1];
                        _glyph_grid[# _insertPos, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _insertPos-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];
                    }
                    else if (_replacementLength - _foundLength == 2)
                    {
                        //Adding two characters
                        _glyph_grid[# _insertPos, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = __SCRIBBLE_DEVANAGARI_OFFSET + _replacementArray[_replacementLength-2];
                        _glyph_grid[# _insertPos, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _insertPos-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];
                        
                        _glyph_grid[# _insertPos+1, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = __SCRIBBLE_DEVANAGARI_OFFSET + _replacementArray[_replacementLength-1];
                        _glyph_grid[# _insertPos+1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = _glyph_grid[# _insertPos-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT];
                    }
                    else
                    {
                        __scribble_error("Devanagari substring insertion length > 2. Please report this error");
                    }
                }
                
                _i           += _replacementLength - 1; //Off-by-one to account for ++_i in the for-loop
                _glyph_count += _replacementLength - _foundLength;
                
                //Recalculate our minibuffer since we've messed around with the array a lot
                _twoChar   =              ((_glyph_grid[# _i+1, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 16);
                _threeChar = _twoChar   | ((_glyph_grid[# _i+2, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 32);
                _fourChar  = _threeChar | ((_glyph_grid[# _i+3, __SCRIBBLE_GEN_GLYPH.__UNICODE] & 0xFFFF) << 48);
            }
        }
    }
    
    #endregion
    
    
    
    #region Copy data across for all the Krutidev characters we've just inserted
    
    var _control_index = 0;
    
    var _font_name            = undefined;
    var _font_glyphs_map      = undefined;
    var _font_glyph_data_grid = undefined;
    
    var _i = 0;
    repeat(_glyph_count)
    {
        var _control_delta = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] - _control_index;
        repeat(_control_delta)
        {
            if (_control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__TYPE] == __SCRIBBLE_GEN_CONTROL_TYPE.__FONT)
            {
                var _font_name            = _control_grid[# _control_index, __SCRIBBLE_GEN_CONTROL.__DATA];
                var _font_data            = __scribble_get_font_data(_font_name);
                var _font_glyph_data_grid = _font_data.__glyph_data_grid;
                var _font_glyphs_map      = _font_data.__glyphs_map;
            }
            
            _control_index++;
        }
        
        var _found_glyph = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE];
        if (_found_glyph == 0xFFFF)
        {
            __scribble_trace("Warning! Devanagari parser extended beyond the end of the available characters");
        }
        else if (_found_glyph >= 32) //Don't transform sprite, surfaces, or stuff that's non-printable
        {
            //Pull info out of the font's data structures
            var _glyph_write = _found_glyph;
            var _data_index = _font_glyphs_map[? _glyph_write];
            
            //If our glyph is missing, choose the missing character glyph instead!
            if (_data_index == undefined)
            {
                __scribble_trace("Couldn't find glyph data for character code " + string(_found_glyph) + " (" + chr(_found_glyph) + ") in font \"" + string(_font_name) + "\"");
                _glyph_write = ord(SCRIBBLE_MISSING_CHARACTER);
                _data_index = _font_glyphs_map[? _glyph_write];
            }
            
            if (_data_index == undefined)
            {
                //This should only happen if SCRIBBLE_MISSING_CHARACTER is missing for a font
                __scribble_trace("Couldn't find glyph data for character code " + string(_glyph_write) + " (" + chr(_glyph_write) + ") in font \"" + string(_font_name) + "\"");
            }
            else if (_font_glyph_data_grid[# _data_index, SCRIBBLE_GLYPH.BIDI] != __SCRIBBLE_BIDI.WHITESPACE) //Don't transform whitespace
            {
                //Add this glyph to our grid by copying from the font's own glyph data grid
                ds_grid_set_grid_region(_glyph_grid, _font_glyph_data_grid, _data_index, SCRIBBLE_GLYPH.UNICODE, _data_index, SCRIBBLE_GLYPH.BILINEAR, _i, __SCRIBBLE_GEN_GLYPH.__UNICODE);
            }
        }
        
        ++_i;
    }
    
    //Create a null terminator so we correctly handle the last character in the string
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__UNICODE      ] = 0x00; //ASCII line break (dec = 10)
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__BIDI         ] = __SCRIBBLE_BIDI.ISOLATED;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__X            ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__Y            ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__WIDTH        ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__HEIGHT       ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__FONT_HEIGHT  ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__SEPARATION   ] = 0;
    _glyph_grid[# _glyph_count, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] = (_glyph_count > 0)? _glyph_grid[# _glyph_count-1, __SCRIBBLE_GEN_GLYPH.__CONTROL_COUNT] : 0; //Make sure we collect controls at the end of a string
    
    _generator_state.__glyph_count = _glyph_count+1;
    
    #endregion
}

function __scribble_debug_krutidev(_glyph_grid)
{
    var _string = "";
    
    var _i = 0;
    while(true)
    {
        var _unicode = _glyph_grid[# _i, __SCRIBBLE_GEN_GLYPH.__UNICODE];
        if (_unicode >= __SCRIBBLE_DEVANAGARI_OFFSET) _unicode -= __SCRIBBLE_DEVANAGARI_OFFSET;
        
        if (_unicode <= 0) break;
        
        _string += chr(_unicode);
        
        ++_i;
    }
    
    return _string;
}
