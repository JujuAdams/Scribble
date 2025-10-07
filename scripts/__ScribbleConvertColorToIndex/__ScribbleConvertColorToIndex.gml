// Feather disable all

/// @param input
/// @param [strict=false]

function __ScribbleConvertColorToIndex(_input, _strict = false)
{
    static _tagDict = __ScribbleSystem().__tagDict;
    
    if (is_numeric(_input))
    {
        return __ScribblePaletteEnsureColor(_input & 0xFFFFFF);
    }
    else if (is_string(_input))
    {
        var _tagStruct = _tagDict[$ _input];
        if (_tagStruct != undefined)
        {
            return (_tagStruct.__type == __SCRIBBLE_TAG_COLOR)? _tagStruct.__data.__index : undefined;
        }
        
        var _decodedColor = undefined;
        try
        {
            _decodedColor = real(_input);
        }
        catch(_error)
        {
            _decodedColor = undefined;
        }
        
        if (_decodedColor != undefined)
        {
            return __ScribblePaletteEnsureColor(_decodedColor & 0xFFFFFF);
        }
        
        var _firstChar = string_copy(_input, 1, 1);
        if ((string_length(_input) <= 7) && ((_firstChar == "$") || (_firstChar == "#")))
        {
            //Hex colour decoding
            //Crafty trick to quickly convert a hex string into a number
            
            try
            {
                _decodedColor = real("0x" + string_delete(_input, 1, 1));
                _decodedColor = __ScribbleRGBToBGR(_decodedColor);
            }
            catch(_error)
            {
                __ScribbleTrace(_error);
                __ScribbleTrace("Error! \"", string_delete(_input, 1, 2), "\" could not be converted into a hexcode");
                _decodedColor = undefined;
            }
            
            return (_decodedColor != undefined)? __ScribblePaletteEnsureColor(_decodedColor & 0xFFFFFF) : undefined;
        }
        else
        {
            var _secondChar = string_copy(_input, 2, 1);
            if (((_firstChar  == "d") || (_firstChar  == "D"))
            &&  ((_secondChar == "$") || (_secondChar == "#")))
            {
                //Decimal colour decoding
                
                try
                {
                    var _decodedColor = real(string_delete(_input, 1, 2));
                }
                catch(_error)
                {
                    __ScribbleTrace(_error);
                    __ScribbleTrace("Error! \"", string_delete(_input, 1, 2), "\" could not be converted into a decimal");
                    _decodedColor = undefined;
                }
                
                return (_decodedColor != undefined)? __ScribblePaletteEnsureColor(_decodedColor & 0xFFFFFF) : undefined;
            }
        }
    }
    
    if (_strict)
    {
        __ScribbleError($"Invalid color information \"{_input}\" (typeof={typeof(_input)})");
    }
    
    return undefined;
}