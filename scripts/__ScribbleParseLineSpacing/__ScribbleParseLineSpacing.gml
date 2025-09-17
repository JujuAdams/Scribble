// Feather disable all

function __ScribbleParseLineSpacing(_value)
{
    static _result = {
        __add: 0,
        __multiply: 0,
    }
    
    if (is_string(_value))
    {
        var _length = string_length(_value);
        if (string_char_at(_value, _length) == "%")
        {
            try
            {
                _result.__add = 0;
                _result.__multiply = real(string_copy(_value, 1, _length-1)) / 100;
            }
            catch(_error)
            {
                __ScribbleTrace(_error);
                __ScribbleError("Could not parse line spacing \"", _value, "\"\nLine spacing must be number or percentage strings e.g. \"200%\"");
            }
        }
        else
        {
            __ScribbleError("Could not parse line spacing \"", _value, "\"\nLine spacing must be number or percentage strings e.g. \"200%\"");
        }
    }
    else
    {
        _result.__add = _value;
        _result.__multiply = 0;
    }
    
    return _result;
}