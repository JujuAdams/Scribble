#macro SCRIBBLE_WARNING_CACHE_GROUP_FLUSH_DEPRECATED  true
if (SCRIBBLE_WARNING_CACHE_GROUP_FLUSH_DEPRECATED)
{
    show_error("Scribble:\nscribble_cache_group_flush() will be deprecated in v6.0.0\nPlease convert your code to use scribble_flush()\n \n(Set SCRIBBLE_WARNING_CACHE_GROUP_FLUSH_DEPRECATED to <false> to hide this warning)\n ", true);
    exit;
}

return scribble_flush(argument0);