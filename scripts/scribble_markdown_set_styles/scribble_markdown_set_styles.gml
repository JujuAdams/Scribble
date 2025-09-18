// Feather disable all
/// @param styleStruct
/// @param [fastMode=false]

function scribble_markdown_set_styles(_rootStruct, _fastMode = false)
{
    static _scribbleState = __ScribbleSystem().__state;
    
    if (not _fastMode)
    {
        //Validate the struct
        //
        //Root struct must only have these children:
        //  body
        //  header1
        //  header2
        //  header3
        //  bold
        //  italic
        //  boldItalic
        //  quote
        //  bulletSprite
        //  link
        //
        //Each formatting type (apart from bulletSprite) can have the following propertes:
        //  font
        //  color
        //  bold
        //  italic
        //  scale
        //  prefix
        //  suffix
        //
        //<font> must be the name of a sprite
        //<color> must be a decimal
        //<bold> and <italic> must be booleans
        //<scale> must be a number
        //<prefix> and <suffix> must be a string
        //<bulletSprite> must be a sprite index or the name of a sprite
        
        if (not is_struct(_rootStruct)) __ScribbleError("Input was not a struct (datatype=", typeof(_rootStruct), ")");
        
        var _rootNamesArray = variable_struct_get_names(_rootStruct);
        var _i = 0;
        repeat(array_length(_rootNamesArray))
        {
            var _rootName = _rootNamesArray[_i];
            
            if ((_rootName != "body")
            &&  (_rootName != "header1")
            &&  (_rootName != "header2")
            &&  (_rootName != "header3")
            &&  (_rootName != "bold")
            &&  (_rootName != "italic")
            &&  (_rootName != "boldItalic")
            &&  (_rootName != "quote")
            &&  (_rootName != "bulletSprite")
            &&  (_rootName != "link"))
            {
                __ScribbleError("Root struct name \"", _rootName, "\" not permitted");
            }
            else
            {
                var _value = _rootStruct[$ _rootName];
                
                if (_rootName == "bulletSprite")
                {
                    if (is_undefined(_value))
                    {
                        //Allowed
                    }
                    else if (is_numeric(_value))
                    {
                        if (not sprite_exists(_value))
                        {
                            __ScribbleError("<bulletSprite> sprite", _value, " does not exist");
                            return false;
                        }
                    }
                    else if (is_string(_value))
                    {
                        if (asset_get_type(_value) != asset_sprite)
                        {
                            __ScribbleError("<bulletSprite> sprite \"", _value, "\" is not a sprite");
                            return false;
                        }
                    }
                    else
                    {
                        __ScribbleError("<bulletSprite> is the wrong datatype. It must be a sprite index or the name of a sprite (datatype=", typeof(_value), ")");
                        return false;
                    }
                }
                else
                {
                    var _childStruct = _value;
                    if (is_undefined(_childStruct))
                    {
                        //Allowed
                    }
                    else if (not is_struct(_childStruct))
                    {
                        __ScribbleError("Child struct <", _rootName, "> must be a struct (datatype=", typeof(_value), ")");
                        return false;
                    }
                    else
                    {
                        var _childNamesArray = variable_struct_get_names(_childStruct);
                        var _j = 0;
                        repeat(array_length(_childNamesArray))
                        {
                            var _childName  = _childNamesArray[_j];
                            var _childValue = _childStruct[$ _childName];
                            
                            if (_childName == "font")
                            {
                                if (is_undefined(_childValue))
                                {
                                    //Allowed
                                }
                                else if (is_string(_childValue))
                                {
                                    if (not scribble_font_exists(_childValue))
                                    {
                                        __ScribbleError("\"font\" property \"", _childValue, "\" is not a font (style=\"", _rootName, "\")");
                                        return false;
                                    }
                                }
                                else
                                {
                                    __ScribbleError("Child struct property \"font\" must be the name of a font as a string (datatype=", typeof(_childValue), ", style=\"", _rootName, "\")");
                                    return false;
                                }
                            }
                            else if ((_childName == "color") || (_childName == "scale"))
                            {
                                if ((not is_numeric(_childValue)) && (not is_undefined(_childValue)))
                                {
                                    __ScribbleError("Child struct property \"", _childName, "\" must be a number (datatype=", typeof(_childValue), ", style=\"", _rootName, "\")");
                                    return false;
                                }
                            }
                            else if ((_childName == "bold") || (_childName == "italic"))
                            {
                                if ((not is_bool(_childValue)) && (not is_undefined(_childValue)))
                                {
                                    __ScribbleError("Child struct property \"bold\" must be `true` or `false` (datatype=", typeof(_childValue), ", style=\"", _rootName, "\")");
                                    return false;
                                }
                            }
                            else if ((_childName == "prefix") || (_childName == "suffix"))
                            {
                                if ((not is_string(_childValue)) && (not is_undefined(_childValue)))
                                {
                                    __ScribbleError("Child struct property \"", _childName, "\" must be a string (datatype=", typeof(_childValue), ", style=\"", _rootName, "\")");
                                    return false;
                                }
                            }
                            else
                            {
                                __ScribbleError("Child struct property <", _rootName, "> not permitted (style=", _rootName, ")");
                                return false;
                            }
                            
                            ++_j;
                        }
                    }
                }
            }
            
            ++_i;
        }
    }
    
    _scribbleState.__markdownStylesStruct = _rootStruct;
    return true;
}
