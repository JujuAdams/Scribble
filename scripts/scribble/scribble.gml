// Feather disable all

/// Returns a Scribble text element corresponding to the input string
/// If a text element with the same input string (and unique ID) has been cached, this function will return the cached text element
/// 
/// @param {String}  string      The string to parse and, eventually, draw
/// @param {Any}     [uniqueID]  A unique identifier that can be used to distinguish this occurrence of the input string from other occurrences. Only necessary when you might be drawing the same string at the same time with different animation states

function scribble(_string, _uniqueID = undefined)
{
    static _elementCacheMap = __scribble_system().__elementCacheMap;
    return _elementCacheMap[? ((_uniqueID == undefined)? SCRIBBLE_DEFAULT_UNIQUE_ID : (string(_uniqueID) + ":")) + string(_string)] ?? new __ScribbleClassCachedElement(string(_string), _uniqueID);
}
