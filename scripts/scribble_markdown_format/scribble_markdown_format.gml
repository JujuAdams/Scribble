// Feather disable all
/// @param string

#macro __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE  _nextValue = buffer_peek(_buffer, buffer_tell(_buffer)-1, buffer_u8);

#macro __SCRIBBLE_MARKDOWN_TOGGLE_BOLD  if (_newStyle == "body")\
                                        {\
                                            _newStyle = "bold";\
                                        }\
                                        else if (_newStyle == "bold")\
                                        {\
                                            _newStyle = "body";\
                                        }\
                                        else if (_newStyle == "italic")\
                                        {\
                                            _newStyle = "boldItalic";\
                                        }\
                                        else if (_newStyle == "boldItalic")\
                                        {\
                                            _newStyle = "italic";\
                                        }\
                                        if (_oldStyle != _newStyle) _writeStyle = true;

#macro __SCRIBBLE_MARKDOWN_TOGGLE_ITALIC  if (_newStyle == "body")\
                                          {\
                                              _newStyle = "italic";\
                                          }\
                                          else if (_newStyle == "italic")\
                                          {\
                                              _newStyle = "body";\
                                          }\
                                          else if (_newStyle == "bold")\
                                          {\
                                              _newStyle = "boldItalic";\
                                          }\
                                          else if (_newStyle == "boldItalic")\
                                          {\
                                              _newStyle = "bold";\
                                          }\
                                          if (_oldStyle != _newStyle) _writeStyle = true;


#macro __SCRIBBLE_MARKDOWN_SET_STYLE  if (_writeStyle)\
                                      {\
                                          _writeStyle = false;\
                                          \
                                          var _oldStyleStruct = (_oldStyle == undefined)? _emptyStruct : (_markdownStylesStruct[$ _oldStyle] ?? _fallbackStylesStruct[$ _oldStyle]);\
                                          var _newStyleStruct = _markdownStylesStruct[$ _newStyle] ?? _fallbackStylesStruct[$ _newStyle];\
                                          \
                                          var _insertString = _oldStyleStruct[$ "suffix"] ?? "";\
                                          \
                                          var _oldValue = _oldStyleStruct[$ "font"];\
                                          var _newValue = _newStyleStruct[$ "font"];\
                                          if (_oldValue != _newValue) _insertString += (_newValue == undefined)? "[/font]" : ("[" + _newValue + "]");\
                                          \
                                          _oldValue = _oldStyleStruct[$ "scale"] ?? 1;\
                                          _newValue = _newStyleStruct[$ "scale"] ?? 1;\
                                          if (_oldValue != _newValue) _insertString += (_newValue == 1)? "[/scale]" : ("[scale," + string(_newValue) + "]");\
                                          \
                                          _oldValue = _oldStyleStruct[$ "color"];\
                                          _newValue = _newStyleStruct[$ "color"];\
                                          if (_oldValue != _newValue) _insertString += (_newValue == undefined)? "[/color]" : ("[d#" + string(_newValue) + "]");\
                                          \
                                          _oldValue = (_oldStyleStruct[$ "italic"] ?? 0) | (2*(_oldStyleStruct[$ "bold"] ?? 0));\
                                          _newValue = (_newStyleStruct[$ "italic"] ?? 0) | (2*(_newStyleStruct[$ "bold"] ?? 0));\
                                          if (_oldValue != _newValue)\
                                          {\
                                              if (_newValue == 0)\
                                              {\
                                                  if (_oldValue == 1)\
                                                  {\
                                                      _insertString += "[/i]";\
                                                  }\
                                                  else if (_oldValue == 2)\
                                                  {\
                                                      _insertString += "[/b]";\
                                                  }\
                                                  else if (_oldValue == 3)\
                                                  {\
                                                      _insertString += "[/bi]";\
                                                  }\
                                              }\
                                              else if (_newValue == 1)\
                                              {\
                                                  _insertString += "[i]";\
                                              }\
                                              else if (_newValue == 2)\
                                              {\
                                                  _insertString += "[b]";\
                                              }\
                                              else if (_newValue == 3)\
                                              {\
                                                  _insertString += "[bi]";\
                                              }\
                                          }\
                                          \
                                          _insertString += _newStyleStruct[$ "prefix"] ?? "";\
                                          \
                                          _bufferSize += _funcInsertBuffer(_buffer, _bufferSize, _insertString);\
                                          \
                                          _oldStyle = _newStyle;\
                                      }



function scribble_markdown_format(_string)
{
    if ((SCRIBBLE_COMMAND_TAG_OPEN     != ord("["))
    ||  (SCRIBBLE_COMMAND_TAG_CLOSE    != ord("]"))
    ||  (SCRIBBLE_COMMAND_TAG_ARGUMENT != ord(",")))
    {
        __ScribbleError("scribble_markdown_format() is not supported with non-standard command tag open/close/argument delimiters\nPlease request this feature if you need it");
        return _string;
    }
    
    static _funcDeleteBuffer = function(_bufferA, _bufferSize, _deleteSize, _pos = buffer_tell(_bufferA)-2)
    {
        static _bufferB = __ScribbleSystem().__bufferB;
        
        var _copyPos  = _pos + _deleteSize;
        var _copySize = _bufferSize - _copyPos;
        
        buffer_copy(_bufferA, _copyPos, _copySize, _bufferB, 0);
        buffer_copy(_bufferB, 0, _copySize, _bufferA, _pos);
        
        buffer_seek(_bufferA, buffer_seek_relative, -1);
        
        return -_deleteSize;
    }
    
    static _funcInsertBuffer = function(_bufferA, _bufferSize, _insertString, _writePos = buffer_tell(_bufferA)-2)
    {
        static _bufferB = __ScribbleSystem().__bufferB;
        
        var _insertSize = string_byte_length(_insertString);
        if (_insertSize <= 0) return 0;
        
        var _copySize   = _bufferSize - _writePos;
        var _recopySize = _insertSize + _copySize;
        
        buffer_poke(_bufferB, 0, buffer_text, _insertString);
        buffer_copy(_bufferA, _writePos, _copySize, _bufferB, _insertSize);
        buffer_copy(_bufferB, 0, _recopySize, _bufferA, _writePos);
        
        buffer_seek(_bufferA, buffer_seek_relative, _insertSize-1);
        
        return _insertSize;
    }
    
    static _funcDeleteAndInsertBuffer = function(_bufferA, _bufferSize, _deleteSize, _insertString = "", _writePos = buffer_tell(_bufferA)-2)
    {
        static _bufferB = __ScribbleSystem().__bufferB;
        
        var _copyPos  = _writePos + _deleteSize;
        var _copySize = _bufferSize - _copyPos;
        
        var _insertSize = string_byte_length(_insertString);
        var _recopySize = _insertSize + _copySize;
        
        buffer_poke(_bufferB, 0, buffer_text, _insertString);
        buffer_copy(_bufferA, _copyPos, _copySize, _bufferB, _insertSize);
        buffer_copy(_bufferB, 0, _recopySize, _bufferA, _writePos);
        
        buffer_seek(_bufferA, buffer_seek_relative, _insertSize-1);
        
        return _insertSize - _deleteSize;
    }
    
    static _emptyStruct = {};
    
    var _fallbackStylesStruct = {
        body: {
        },
        
        header1: {
            bold:   true,
            italic: true,
            scale:  1.6,
        },
        
        header2: {
            bold:  true,
            scale: 1.4,
        },
        
        header3: {
            italic: true,
            scale:  1.2,
        },
        
        quote: {
            color:  #E7E7E7,
            italic: true,
            scale:  0.9,
            prefix: "  ",
        },
        
        bold: {
            bold: true,
        },
        
        italic: {
            italic: true,
        },
        
        boldItalic: {
            bold:   true,
            italic: true,
        },
        
        bulletSprite: sprScribbleFallbackBulletpoint,
        
        link: {
            bold:  true,
            color: #DF9FFF,
        },
    };
    
    var _markdownStylesStruct = __ScribbleSystem().__state.__markdownStylesStruct;
    
    static _buffer = __ScribbleSystem().__bufferA;
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    buffer_write(_buffer, buffer_string, _string);
    var _bufferSize = buffer_tell(_buffer);
    buffer_seek(_buffer, buffer_seek_start, 0);
    
    var _oldStyle   = undefined;
    var _newStyle   = "body";
    var _writeStyle = true;
    
    var _newline = true;
    var _indent  = false;
    var _inLink  = false;
    
    var _prevValue = 0;
    var _value     = 0;
    var _nextValue = buffer_read(_buffer, buffer_u8);
    
    while(true)
    {
        if (_nextValue == 0) break;
        
        _value = _nextValue;
        var _nextValue = buffer_read(_buffer, buffer_u8);
        
        //Newline
        if ((_value == 10) || (_value == 13))
        {
            _newline = true;
            
            if (_indent)
            {
                _indent = false;
                _bufferSize += _funcInsertBuffer(_buffer, _bufferSize, "[/indent]", buffer_tell(_buffer)-2);
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
            }
            
            if (!_writeStyle
            && ((_oldStyle == "quote")
             || (_oldStyle == "header1")
             || (_oldStyle == "header2")
             || (_oldStyle == "header3")))
            {
                _newStyle = "body";
                _writeStyle = true;
            }
            
            continue;
        }
        
        //Searching for the first character on a line
        if (_newline)
        {
            if ((_value == ord(">")) && (_nextValue == 0x20)) //Quote
            {
                _newStyle = "quote";
                if (_oldStyle != _newStyle)
                {
                    _writeStyle = true;
                    __SCRIBBLE_MARKDOWN_SET_STYLE
                    buffer_seek(_buffer, buffer_seek_relative, 1);
                }
                
                if (_indent)
                {
                    __ScribbleTrace("Warning! Found stacked indentation");
                    _bufferSize += _funcDeleteBuffer(_buffer, _bufferSize, 2);
                }
                else
                {
                    _indent = true;
                    _bufferSize += _funcDeleteAndInsertBuffer(_buffer, _bufferSize, 2, "[indent]");
                }
                
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                
                _newline = false;
                continue;
            }
            else if (_value == ord("#")) //Header
            {
                var _headerLevel = 1;
                var _headerPeek = buffer_tell(_buffer)-1;
                
                while(true)
                {
                    var _headerNextValue = buffer_peek(_buffer, _headerPeek, buffer_u8);
                    if (_headerNextValue == 0x00)
                    {
                        _headerLevel = 0;
                        break;
                    }
                    else if (_headerNextValue == ord(" "))
                    {
                        break;
                    }
                    else if (_headerNextValue != ord("#"))
                    {
                        _headerLevel = 0;
                        break;
                    }
                    
                    ++_headerLevel;
                    ++_headerPeek;
                }
                
                if (_headerLevel > 0)
                {
                    if (_headerLevel == 1)
                    {
                        _newStyle = "header1";
                    }
                    else if (_headerLevel == 2)
                    {
                        _newStyle = "header2";
                    }
                    else if (_headerLevel >= 3)
                    {
                        _newStyle = "header3";
                    }
                    
                    if (_oldStyle != _newStyle) _writeStyle = true;
                    
                    _bufferSize += _funcDeleteBuffer(_buffer, _bufferSize, _headerLevel+1);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                    
                    _newline = false;
                    continue;
                }
            }
            else if (((_value == ord("-")) || (_value == ord("*"))) && (_nextValue == 0x20)) //Unordered list
            {
                _newStyle = "body";
                if (_oldStyle != _newStyle)
                {
                    _writeStyle = true;
                    __SCRIBBLE_MARKDOWN_SET_STYLE
                    buffer_seek(_buffer, buffer_seek_relative, 1);
                }
                
                var _bulletSprite = _markdownStylesStruct[$ "bulletSprite"];
                if (_indent)
                {
                    __ScribbleTrace("Warning! Found stacked indentation");
                    _bufferSize += _funcDeleteAndInsertBuffer(_buffer, _bufferSize, 2, (_bulletSprite == undefined)? "- " : "[" + sprite_get_name(_bulletSprite) + "] ");
                }
                else
                {
                    _indent = true;
                    _bufferSize += _funcDeleteAndInsertBuffer(_buffer, _bufferSize, 2, (_bulletSprite == undefined)? "- [indent]" : "[" + sprite_get_name(_bulletSprite) + "] [indent]");
                }
                
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                
                _newline = false;
                continue;
            }
            else if ((_value >= 48) && (_value <= 57)) //Ordered list
            {
                var _numberSize = 1;
                var _numberPeek = buffer_tell(_buffer)-1;
                
                while(true)
                {
                    var _numberNextValue = buffer_peek(_buffer, _numberPeek, buffer_u8);
                    if (_numberNextValue == 0x00)
                    {
                        _numberSize = 0;
                        break;
                    }
                    else if ((_numberNextValue == ord(".")) || (_numberNextValue == ord(")")))
                    {
                        break;
                    }
                    else if ((_numberNextValue < 48) || (_numberNextValue > 57))
                    {
                        _numberSize = 0;
                        break;
                    }
                    
                    ++_numberSize;
                    ++_numberPeek;
                }
                
                if (_numberSize > 0)
                {
                    _newStyle = "body";
                    if (_oldStyle != _newStyle)
                    {
                        _writeStyle = true;
                        __SCRIBBLE_MARKDOWN_SET_STYLE
                        buffer_seek(_buffer, buffer_seek_relative, 1);
                    }
                    
                    buffer_seek(_buffer, buffer_seek_relative, _numberSize+2);
                    
                    if (_indent)
                    {
                        __ScribbleTrace("Warning! Found stacked indentation");
                    }
                    else
                    {
                        _indent = true;
                        _bufferSize += _funcInsertBuffer(_buffer, _bufferSize, "[indent]");
                    }
                    
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                    _prevValue = 0x20; //Force the previous value to a space
                }
                
                _newline = false;
                continue;
            }
            
            if (_value <= 0x20) continue;
            
            _newline = false;
            //Fall through to parse the first character
        }
        
        
        
        //Parse body
        if (_value == ord("*")) //Bold + italic
        {
            if (_nextValue == ord("*"))
            {
                __SCRIBBLE_MARKDOWN_TOGGLE_BOLD
                var _deleteSize = 2;
            }
            else
            {
                __SCRIBBLE_MARKDOWN_TOGGLE_ITALIC
                var _deleteSize = 1;
            }
            
            _bufferSize += _funcDeleteBuffer(_buffer, _bufferSize, _deleteSize);
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else if ((_value == ord("_")) && ((_prevValue <= 0x20) || (_nextValue <= 0x20))) //Italic only
        {
            __SCRIBBLE_MARKDOWN_TOGGLE_ITALIC
            
            _bufferSize += _funcDeleteBuffer(_buffer, _bufferSize, 1);
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else if ((_value == ord("!")) && (_nextValue == ord("["))) //Image
        {
            //Delete !
            _bufferSize += _funcDeleteBuffer(_buffer, _bufferSize, 1);
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else if (_value == ord("\\")) //Escape character
        {
            if (_nextValue == 0) return;
            
            //Delete \
            _bufferSize += _funcDeleteBuffer(_buffer, _bufferSize, 1);
            buffer_seek(_buffer, buffer_seek_relative, 1); //Skip the next character
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
        }
        else if (_inLink && (_value == ord("]")) && (_nextValue == ord("(")))
        {
            //Delete ](
            _bufferSize += _funcDeleteAndInsertBuffer(_buffer, _bufferSize, 2, "[/region]");
            __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
            
            _newStyle = "body";
            if (_oldStyle != _newStyle) _writeStyle = true;
            
            _inLink = false;
        }
        else
        {
            if (!_inLink && (_value == ord("["))) //Links
            {
                #region [text](region)
                
                //Look for the end of the link
                var _isLink    = false;
                var _linkSize  = 1;
                var _linkStart = buffer_tell(_buffer)-2;
                var _linkPeek  = _linkStart+1;
                
                while(true)
                {
                    var _linkNextValue = buffer_peek(_buffer, _linkPeek, buffer_u8);
                    if (_linkNextValue == 0x00)
                    {
                        break;
                    }
                    else if (_linkNextValue == ord("]"))
                    {
                        ++_linkPeek;
                        
                        if (buffer_peek(_buffer, _linkPeek, buffer_u8) == ord("("))
                        {
                            _isLink = true;
                            break;
                        }
                        
                        ++_linkSize;
                    }
                    else
                    {
                        ++_linkSize;
                        ++_linkPeek;
                    }
                }
                
                if (_isLink)
                {
                    _isLink = false;
                    
                    //Look for the name of the region (which would otherwise be a URL in markdown)
                    var _regionStart = _linkPeek+1;
                    var _regionEnd   = _regionStart;
                    
                    while(true)
                    {
                        var _regionNextValue = buffer_peek(_buffer, _regionEnd, buffer_u8);
                        if ((_regionNextValue == 0x00) || (_regionNextValue == ord(")"))) break;
                        ++_regionEnd;
                    }
                    
                    buffer_poke(_buffer, _regionEnd, buffer_u8, 0x00);
                    var _regionName = buffer_peek(_buffer, _regionStart, buffer_string);
                    
                    _bufferSize += _funcDeleteBuffer(_buffer, _bufferSize, 1 + _regionEnd - _regionStart, _regionStart);
                    _bufferSize += _funcInsertBuffer(_buffer, _bufferSize, "region," + _regionName + "]", _linkStart+1);
                    buffer_seek(_buffer, buffer_seek_relative, 2);
                    __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
                    
                    _inLink = true;
                    _newStyle = "link";
                    if (_oldStyle != _newStyle) _writeStyle = true;
                    
                    continue;
                }
                
                #endregion
            }
            
            _prevValue = _value;
            
            if (_value > 0x20)
            {
                __SCRIBBLE_MARKDOWN_SET_STYLE
                __SCRIBBLE_MARKDOWN_UPDATE_NEXT_VALUE
            }
        }
    }
    
    buffer_seek(_buffer, buffer_seek_start, 0);
    return buffer_read(_buffer, buffer_string);
}
