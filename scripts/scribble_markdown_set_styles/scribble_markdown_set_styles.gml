// Feather disable all
/// @param styleStruct
/// @param [fastMode=false]

function scribble_markdown_set_styles(_root_struct, _fast_mode = false)
{
    static _scribbleState = __ScribbleSystem().__state;
    
    if (!_fast_mode)
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
        //  bold_italic
        //  quote
        //  bullet_sprite
        //  link
        //
        //Each formatting type (apart from bullet_sprite) can have the following propertes:
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
        //<bullet_sprite> must be a sprite index or the name of a sprite
        
        if (!is_struct(_root_struct)) __ScribbleError("Input was not a struct (datatype=", typeof(_root_struct), ")");
        
        var _root_names_array = variable_struct_get_names(_root_struct);
        var _i = 0;
        repeat(array_length(_root_names_array))
        {
            var _root_name = _root_names_array[_i];
            
            if ((_root_name != "body")
            &&  (_root_name != "header1")
            &&  (_root_name != "header2")
            &&  (_root_name != "header3")
            &&  (_root_name != "bold")
            &&  (_root_name != "italic")
            &&  (_root_name != "bold_italic")
            &&  (_root_name != "quote")
            &&  (_root_name != "bullet_sprite")
            &&  (_root_name != "link"))
            {
                __ScribbleError("Root struct name \"", _root_name, "\" not permitted");
            }
            else
            {
                var _value = _root_struct[$ _root_name];
                
                if (_root_name == "bullet_sprite")
                {
                    if (is_undefined(_value))
                    {
                        //Allowed
                    }
                    else if (is_numeric(_value))
                    {
                        if (!sprite_exists(_value))
                        {
                            __ScribbleError("<bullet_sprite> sprite", _value, " does not exist");
                            return false;
                        }
                    }
                    else if (is_string(_value))
                    {
                        if (asset_get_type(_value) != asset_sprite)
                        {
                            __ScribbleError("<bullet_sprite> sprite \"", _value, "\" is not a sprite");
                            return false;
                        }
                    }
                    else
                    {
                        __ScribbleError("<bullet_sprite> is the wrong datatype. It must be a sprite index or the name of a sprite (datatype=", typeof(_value), ")");
                        return false;
                    }
                }
                else
                {
                    var _child_struct = _value;
                    if (is_undefined(_child_struct))
                    {
                        //Allowed
                    }
                    else if (!is_struct(_child_struct))
                    {
                        __ScribbleError("Child struct <", _root_name, "> must be a struct (datatype=", typeof(_value), ")");
                        return false;
                    }
                    else
                    {
                        var _child_names_array = variable_struct_get_names(_child_struct);
                        var _j = 0;
                        repeat(array_length(_child_names_array))
                        {
                            var _child_name  = _child_names_array[_j];
                            var _child_value = _child_struct[$ _child_name];
                            
                            if (_child_name == "font")
                            {
                                if (is_undefined(_child_value))
                                {
                                    //Allowed
                                }
                                else if (is_string(_child_value))
                                {
                                    if (!scribble_font_exists(_child_value))
                                    {
                                        __ScribbleError("\"font\" property \"", _child_value, "\" is not a font (style=\"", _root_name, "\")");
                                        return false;
                                    }
                                }
                                else
                                {
                                    __ScribbleError("Child struct property \"font\" must be the name of a font as a string (datatype=", typeof(_child_value), ", style=\"", _root_name, "\")");
                                    return false;
                                }
                            }
                            else if ((_child_name == "color") || (_child_name == "scale"))
                            {
                                if (!is_numeric(_child_value) && !is_undefined(_child_value))
                                {
                                    __ScribbleError("Child struct property \"", _child_name, "\" must be a number (datatype=", typeof(_child_value), ", style=\"", _root_name, "\")");
                                    return false;
                                }
                            }
                            else if ((_child_name == "bold") || (_child_name == "italic"))
                            {
                                if (!is_bool(_child_value) && !is_undefined(_child_value))
                                {
                                    __ScribbleError("Child struct property \"bold\" must be <true> or <false> (datatype=", typeof(_child_value), ", style=\"", _root_name, "\")");
                                    return false;
                                }
                            }
                            else if ((_child_name == "prefix") || (_child_name == "suffix"))
                            {
                                if (!is_string(_child_value) && !is_undefined(_child_value))
                                {
                                    __ScribbleError("Child struct property \"", _child_name, "\" must be a string (datatype=", typeof(_child_value), ", style=\"", _root_name, "\")");
                                    return false;
                                }
                            }
                            else
                            {
                                __ScribbleError("Child struct property <", _root_name, "> not permitted (style=", _root_name, ")");
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
    
    _scribbleState.__markdown_styles_struct = _root_struct;
    return true;
}
