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



#region Build find-replace lookup table

var _unicodeSourceArray = [
    "‘",   "’",   "“",   "”",   "(",    ")",   "{",    "}",   "=", "।",  "?",  "-",  "µ", "॰", ",", ".",
	"०",  "१",  "२",  "३",     "४",   "५",  "६",   "७",   "८",   "९", "x", 

	"फ़्",  "क़",  "ख़",  "ग़", "ज़्", "ज़",  "ड़",  "ढ़",   "फ़",  "य़",  "ऱ",  "ऩ",  
	"त्त्",   "त्त",     "क्त",  "दृ",  "कृ",

	"ह्न",  "ह्य",  "हृ",  "ह्म",  "ह्र",  "ह्",   "द्द",  "क्ष्", "क्ष", "त्र्", "त्र","ज्ञ",
	"छ्य",  "ट्य",  "ठ्य",  "ड्य",  "ढ्य", "द्य","द्व",
	"श्र",  "ट्र",    "ड्र",    "ढ्र",    "छ्र",   "क्र",  "फ्र",  "द्र",   "प्र",   "ग्र", "रु",  "रू",
	"्र",

	"ओ",  "औ",  "आ",   "अ",   "ई",   "इ",  "उ",   "ऊ",  "ऐ",  "ए", "ऋ",

	"क्",  "क",  "क्क",  "ख्",   "ख",    "ग्",   "ग",  "घ्",  "घ",    "ङ",
	"चै",   "च्",   "च",   "छ",  "ज्", "ज",   "झ्",  "झ",   "ञ",

	"ट्ट",   "ट्ठ",   "ट",   "ठ",   "ड्ड",   "ड्ढ",  "ड",   "ढ",  "ण्", "ण",  
	"त्",  "त",  "थ्", "थ",  "द्ध",  "द", "ध्", "ध",  "न्",  "न",  

	"प्",  "प",  "फ्", "फ",  "ब्",  "ब", "भ्",  "भ",  "म्",  "म",
	"य्",  "य",  "र",  "ल्", "ल",  "ळ",  "व्",  "व", 
	"श्", "श",  "ष्", "ष",  "स्",   "स",   "ह",     

	"ऑ",   "ॉ",  "ो",   "ौ",   "ा",   "ी",   "ु",   "ू",   "ृ",   "े",   "ै",
	"ं",   "ँ",   "ः",   "ॅ",    "ऽ", chr(0x94D), //virama
];
    
var _krutidevSourceArray = [
    "^", "*",  "Þ", "ß", "¼", "½", "¿", "À", "¾", "A", "\\", "&", "&", "Œ", "]","-", 
	"å",  "ƒ",  "„",   "…",   "†",   "‡",   "ˆ",   "‰",   "Š",   "‹","Û",

	"¶",   "d",    "[k",  "x",  "T",  "t",   "M+", "<+", "Q",  ";",    "j",   "u",
	"Ù",   "Ùk",   "Dr",    "–",   "—",       

	"à",   "á",    "â",   "ã",   "ºz",  "º",   "í", "{", "{k",  "«", "=","K", 
	"Nî",   "Vî",    "Bî",   "Mî",   "<î", "|","}",
	"J",   "Vª",   "Mª",  "<ªª",  "Nª",   "Ø",  "Ý",   "æ", "ç", "xz", "#", ":",
	"z",

	"vks",  "vkS",  "vk",    "v",   "bZ",  "b",  "m",  "Å",  ",s",  ",",   "_",

	"D",  "d",    "ô",     "[",     "[k",    "X",   "x",  "?",    "?k",   "³", 
	"pkS",  "P",    "p",  "N",   "T",    "t",   "÷",  ">",   "¥",

	"ê",      "ë",      "V",  "B",   "ì",       "ï",     "M",  "<",  ".", ".k",   
	"R",  "r",   "F", "Fk",  ")",    "n", "/",  "/k",  "U", "u",   

	"I",  "i",   "¶", "Q",   "C",  "c",  "H",  "Hk", "E",   "e",
	"¸",   ";",    "j",  "Y",   "y",  "G",  "O",  "o",
	"'", "'k",  "\"", "\"k", "L",   "l",   "g",      

	"v‚",    "‚",    "ks",   "kS",   "k",     "h",    "q",   "w",   "`",    "s",    "S",
	"a",    "¡",    "%",     "W",   "·", "~",
];

//Use a ds_map rather than a struct since our keys will be integers
global.__scribble_krutidev_lookup_map = ds_map_create();
    
var _i = 0;
repeat(array_length(_unicodeSourceArray))
{
    var _string = _unicodeSourceArray[_i];
        
    var _searchInteger = 0;
    var _j = string_length(_string);
    repeat(_j)
    {
        _searchInteger = (_searchInteger << 16) | ord(string_char_at(_string, _j));
        --_j;
    }
        
    var _string = _krutidevSourceArray[_i];
    var _writeArray = [];
    var _j = 1;
    repeat(string_length(_string))
    {
        array_push(_writeArray, ord(string_char_at(_string, _j)));
        ++_j;
    }
        
    global.__scribble_krutidev_lookup_map[? _searchInteger] = _writeArray;
        
    ++_i;
}
    
#endregion



#region Build matra lookup table

//Use a ds_map rather than a struct since our keys are integers
global.__scribble_krutidev_matra_lookup_map = ds_map_create();
global.__scribble_krutidev_matra_lookup_map[?   58] = true;
global.__scribble_krutidev_matra_lookup_map[? 2305] = true;
global.__scribble_krutidev_matra_lookup_map[? 2306] = true;
global.__scribble_krutidev_matra_lookup_map[? 2366] = true;
global.__scribble_krutidev_matra_lookup_map[? 2367] = true;
global.__scribble_krutidev_matra_lookup_map[? 2368] = true;
global.__scribble_krutidev_matra_lookup_map[? 2369] = true;
global.__scribble_krutidev_matra_lookup_map[? 2370] = true;
global.__scribble_krutidev_matra_lookup_map[? 2371] = true;
global.__scribble_krutidev_matra_lookup_map[? 2373] = true;
global.__scribble_krutidev_matra_lookup_map[? 2375] = true;
global.__scribble_krutidev_matra_lookup_map[? 2376] = true;
global.__scribble_krutidev_matra_lookup_map[? 2379] = true;
global.__scribble_krutidev_matra_lookup_map[? 2380] = true;
    
#endregion



function UnicodeToKrutidev(_inString)
{
    //Convert the string into an array
    var _stringLength = string_length(_inString);
    //Pad the end because we'll need to read beyond the end of the string during the final find-replace
    //We pad with 0xFFFF to avoid accidentally making incorrect substring matches later
    var _charArray = array_create(_stringLength + 4, 0xFFFF);
    
    var _i = 0;
    repeat(_stringLength)
    {
        _charArray[@ _i] = ord(string_char_at(_inString, _i+1));
        ++_i;
    }
    
    
    
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
    
    var _matraLookupMap = global.__scribble_krutidev_matra_lookup_map;
    
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
    
    var _lookupMap = global.__scribble_krutidev_lookup_map;
    
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
    
    
    
    //Convert the array back into a string
    var _outString = "";
    var _i = 0;
    repeat(_stringLength)
    {
        _outString += chr(_charArray[_i]);
        ++_i;
    }
    
    return _outString;
}
