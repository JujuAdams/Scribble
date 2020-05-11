/// Sets Scribble's current cache group
/// 
/// @param cacheGroup   Cache group that stores the Scribble data. If this argument is <undefined>, the default cache group will be used instead.
/// @param allowDraw    Whether to draw the text. Defaults to <true>. Set this optional argument to <false> to pre-cache text.
/// @param freeze       Whether to freeze the vertex buffers or not. Substantially increase up-front caching cost but makes drawing faster
/// 
/// Scribble uses cache groups to help manage memory. Scribble text that has been added to a cache group will be automatically
/// destroyed if one of two things happens:
///   1. scribble_cache_group_flush() has been called targetting the text's cache group
///   2. The text has not been drawn for a period of time (SCRIBBLE_CACHE_TIMEOUT milliseconds)
/// 
/// By default, all Scribble data is put into the same cache group, defined by the macro SCRIBBLE_DEFAULT_CACHE_GROUP. Using
/// scribble_draw_set_cache_group, you can specify a different cache group to manage memory more easily (e.g. one cache group
/// for dialogue, another for an inventory screen).
/// 
/// Setting the macro SCRIBBLE_CACHE_TIMEOUT to 0 stops text from being flushed if it hasn't been drawn for a while; instead,
/// you'll need to manually call scribble_cache_group_flush(), targetting the relevant cache group.
/// 
/// If you're manually creating text elements by calling scribble_draw() directly, you can choose to opt out of using any cache.
/// By setting the cacheGroup argument to undefined, Scribble will skip adding the data to the cache. However, this means that
/// the data you create will not be automatically destroyed. To free memory you will have to call scribble_cache_group_flush()
/// manually, using the Scribble text element as the argument.

global.scribble_state_cache_group = (argument0 != undefined)? argument0 : SCRIBBLE_DEFAULT_CACHE_GROUP;
global.scribble_state_allow_draw  = argument1;
global.scribble_state_freeze      = argument2;