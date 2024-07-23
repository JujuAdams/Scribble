// Feather disable all
/// Unicode to Krutidev
/// @jujuadams  2022-01-29
/// 
/// Krutidev is an old font format that allows for Devanagari ("Hindi") to be rendered without relying
/// on GSUB and GPOS tables found in modern .ttf font files. GameMaker doesn't allow us to access GPOS
/// and GSUB tables so this is the best we have until someone puts together a .ttf file reader.
/// 
/// Krutidev works by inserting Devanagari glyphs into a font by overwriting Latin character slots.
/// For example, "k" is replaced by "ा". Devanagari glyphs can get quite complicated, for example "ह्न"
/// is made up of three Unicode characters but is represented in Krutidev using "à".
/// 
/// This function converts Unicode-formatted Devanagari into the necessary Latin characters so that
/// when the outputted string is rendered using a Krutidev font the Devanagari glyphs are comfortably
/// readable to the player.
/// 
/// There are, of course, more Devanagari glyph variants than there are Latin characters. This means
/// that Krutidev fonts need to be set up with an expanded range of glyphs. Judging by the sample font
/// I found (Krutidev 010), the glyph ranges required are:
///   32 ->  126        0x0020 -> 0x007E
///  144                0x0090
///  160 ->  249        0x00A0 -> 0x00F9
///  338                0x0152
///  352                0x0160
///  376                0x0178
///  402                0x0192
///  710                0x02C6
///  732                0x02DC
/// 8208                0x2010
/// 8211 -> 8212        0x2013 -> 0x2014
/// 8216 -> 8218        0x2018 -> 0x201A
/// 8220 -> 8225        0x201C -> 0x2021
/// 8230                0x2026
/// 8240                0x2030
/// 8249 -> 8250        0x2039 -> 0x203A
/// 8482                0x2122
/// This list may not be exhaustive. I highly recommend grabbing FontForge to help determined what
/// glyphs are available in your font of choice.
/// 
/// Using Krutidev to render Devanagari has drawbacks:
/// 1) Only Krutidev fonts can be used with Krutidev-formatted text. There seem to be a *lot* of
///    Krutidev fonts out there but that may dry up over time. I found a website that seems to
///    host a bazillion Krutidev fonts: https://www.wfonts.com/search?kwd=Kruti+Dev
/// 2) Krutidev doesn't have a lot of the fancier Devanagari glyphs. I am unsure exactly what is
///    missing - I'm not a native Hindi speaker - so don't be surprised if some text doesn't look
///    quite right to people familiar with the language.
/// 3) Since Krutidev fonts replace Western characters with Devanagari glyphs, this means it is
///    not possible to draw Latin script and Devanagari script from the same font. This is a bit
///    of a pain but can be worked around if you're desperate.
/// 4) Setting Krutidev font glyph ranges is a faff. Not the worst thing in the world, but worth
///    bearing in mind.
/// 
/// @param unicodeString

function StringDevanagariParse(_inString)
{
    static _matraLookupMap = GlyphData().devanagariMatraMap;
    static _lookupMap      = GlyphData().devanagariLookupMap;
    
    var _charArray = StringDecompose(_inString);
    var _stringLength = array_length(_charArray);
    
    array_push(_charArray, 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF);
    
    
    
    #region Transform quotes and split up nukta ligatures
    
    var _inSingleQuote = false;
    var _inDoubleQuote = false;
    var _i = 0;
    repeat(_stringLength)
    {
        switch(_charArray[_i])
        {
            //Set up alternating single quote marks
            case ord("'"):
                _inSingleQuote = !_inSingleQuote;
                _charArray[@ _i] = _inSingleQuote? ord("^") : ord("*");
            break;
            
            //Set up alternating double quote marks
            case ord("\""):
                _inDoubleQuote = !_inDoubleQuote;
                _charArray[@ _i] = _inDoubleQuote? ord("ß") : ord("Þ");
            break;
            
            //Split up nukta ligatures into their componant parts
            case ord("ऩ"):
                _charArray[@ _i] = ord("न");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ऱ"):
                _charArray[@ _i] = ord("र");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("क़"):
                _charArray[@ _i] = ord("क");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ख़"):
                _charArray[@ _i] = ord("ख");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ग़"):
                _charArray[@ _i] = ord("ग");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ज़"):
                _charArray[@ _i] = ord("ज");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ड़"):
                _charArray[@ _i] = ord("ड");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("ढ़"):
                _charArray[@ _i] = ord("ढ");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("फ़"):
                _charArray[@ _i] = ord("फ");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
            
            case ord("य़"):
                _charArray[@ _i] = ord("य");
                array_insert(_charArray, _i+1, 0x093C); ++_i; ++_stringLength; //Nukta
            break;
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Reposition ि  to the front of the word and replace it with an "f"
    
    //TODO - Log where ि  is found during the nukta ligature sweep
    var _i = 1; //Start at the second char because we don't care if the string starts with 0x093F (Vowel Sign I)
    repeat(_stringLength-1)
    {
        var _char = _charArray[_i];
        if (_char == ord("ि"))
        {
            var _fPosition = _i;
            
            var _j = _i - 1;
            while(_j >= 0)
            {
                if (_charArray[_j] == 0x094D)
                {
                    //If we find a virama behind us keep tracking backwards
                    //We go two indexes backwards because virama (should) always follows another character
                    _j -= 2;
                }
                else if (_charArray[_j] == 0x093C) //Nukta
                {
                    _j -= 1;
                }
                else
                {
                    break;
                }
            }
            
            array_delete(_charArray, _fPosition, 1);
            array_insert(_charArray, _j, ord("f"));
            
            _i = _fPosition;
        }
        
        ++_i;
    }
    
    #endregion
    
    
    
    #region Move र् (ra + virama) after matras
    
    //Using a for-loop here as _stringLength may change
    for(var _i = 0; _i < _stringLength; ++_i)
    {
        //TODO - Log where ra-virama is found during the nukta ligature sweep
        if ((_charArray[_i] == ord("र")) && (_charArray[_i+1] == 0x094D)) //Ra followed by virama
        {
            var _probablePosition = _i + 3;
            
            var _charRight = _charArray[_probablePosition];
            while(ds_map_exists(_matraLookupMap, _charRight))
            {
                _probablePosition++;
                _charRight = _charArray[_probablePosition];
            }
            
            array_insert(_charArray, _probablePosition, ord("Z"));
            array_delete(_charArray, _i, 2);
            
            --_stringLength;
        }
    }
    
    #endregion
    
    
    
    #region Perform bulk find-replace
    
    //Create a 64-bit minibuffer
    //Fortunately all the characters we're looking for fit into 16 bits and we only need to look for 4 at a time
    var _oneChar   =                                0x0000;
    var _twoChar   =              ((_charArray[0] & 0xFFFF) << 16);
    var _threeChar = _twoChar   | ((_charArray[1] & 0xFFFF) << 32);
    var _fourChar  = _threeChar | ((_charArray[2] & 0xFFFF) << 48);
    
    //Using a for-loop here as _stringLength may change
    for(var _i = 0; _i < _stringLength; ++_i;)
    {
        _oneChar   = _twoChar   >> 16;
        _twoChar   = _threeChar >> 16;
        _threeChar = _fourChar  >> 16;
        _fourChar  = _threeChar | ((_charArray[_i + 3] & 0xFFFF) << 48);
        
        //Try to find a matching substring
        var _foundLength = 4;
        var _replacementArray = _lookupMap[? _fourChar];
        
        if (_replacementArray == undefined)
        {
            _foundLength = 3;
            _replacementArray = _lookupMap[? _threeChar];
            
            if (_replacementArray == undefined)
            {
                _foundLength = 2;
                _replacementArray = _lookupMap[? _twoChar];
                
                if (_replacementArray == undefined)
                {
                    _foundLength = 1;
                    _replacementArray = _lookupMap[? _oneChar];
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
                _charArray[@ _i] = _replacementArray[0];
            }
            else
            {
                //Heavyweight general replacement code... we want to avoid as many delete/insert commands as
                //possible as it causes lots of reallocation in the background
                
                //Copy over as much data as possible from one array
                var _copyCount = min(_foundLength, _replacementLength);
                array_copy(_charArray, _i, _replacementArray, 0, _copyCount);
                
                if (_foundLength > _replacementLength)
                {
                    //If we're replacing with fewer characters than we found then we need to delete some characters
                    array_delete(_charArray, _i + _copyCount, _foundLength - _replacementLength);
                }
                else
                {
                    //Otherwise, we're adding characters to the array so we have to insert some characters
                    switch(_replacementLength - _foundLength)
                    {
                        case 1:
                            array_insert(_charArray, _i + _copyCount, _replacementArray[_copyCount]);
                        break;
                        
                        //I'm not sure the 2 or 3 case ever happens but we should cover it just in case
                        case 2:
                            array_insert(_charArray, _i + _copyCount,
                                         _replacementArray[_copyCount  ],
                                         _replacementArray[_copyCount+1]);
                        break;
                        
                        case 3:
                            array_insert(_charArray, _i + _copyCount,
                                         _replacementArray[_copyCount  ],
                                         _replacementArray[_copyCount+1],
                                         _replacementArray[_copyCount+2]);
                        break;
                    }
                }
                
                _i            += _replacementLength - 1; //Off-by-one to account for ++_i in the for-loop
                _stringLength += _replacementLength - _foundLength;
                
                //Recalculate our minibuffer since we've messed around with the array a lot
                _twoChar   =              ((_charArray[_i+1] & 0xFFFF) << 16);
                _threeChar = _twoChar   | ((_charArray[_i+2] & 0xFFFF) << 32);
                _fourChar  = _threeChar | ((_charArray[_i+3] & 0xFFFF) << 48);
            }
        }
    }
    
    #endregion
    
    
    
    array_resize(_charArray, array_length(_charArray)-4);
    
    return StringRecompose(_charArray);
}