/// Sets Scribble's current cache group
/// 
/// 
/// @param cacheGroup   The cache group that stores the Scribble data. If this argument is <undefined>, the default cache group will be used instead.
/// @param allowDraw    Whether to draw the text. Defaults to <true>. Set this optional arugment to <false> to pre-cache text.
/// @param freeze       Whether to freeze the vertex buffers or not. Substantially increase up-front caching cost but makes drawing faster
/// 
/// 
/// Scribble uses cache groups to help manage memory. Scribble text that has been added to a cache group will be automatically destroyed if...
/// 1) scribble_flush() has been called targetting the text's cache group
/// 2) or the text has not been drawn for a period of time (SCRIBBLE_CACHE_TIMEOUT milliseconds).
/// By default, all Scribble data is put into the same cache group: SCRIBBLE_DEFAULT_CACHE_GROUP. You can specify a different cache group
/// to manage memory more easily (e.g. one cache group for dialogue, another for an inventory screen). Setting SCRIBBLE_CACHE_TIMEOUT to 0
/// halts all time-based memory management; instead, you'll need to manually call scribble_flush(), targetting the relevant cache group(s).
/// 
/// If you're manually creating text elements by calling scribble_draw() directly, you can choose to opt out of using the cache. By setting
/// the "cacheGroup" argument to <undefined>, Scribble will skip adding the data to the cache. However, this means that the data you create
/// *will not be automatically destroyed*. To free memory you will have to call scribble_flush() manually, using the Scribble text  array as
/// the argument.
/// 
/// To track how much Scribble data exists at any one time, call ds_map_size(global.scribble_alive).

global.scribble_state_cache_group = (argument0 != undefined)? argument0 : SCRIBBLE_DEFAULT_CACHE_GROUP;
global.scribble_state_allow_draw  = argument1;
global.scribble_state_freeze      = argument2;