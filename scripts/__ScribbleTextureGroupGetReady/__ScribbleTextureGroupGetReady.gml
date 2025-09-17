// Feather disable all

/// @param textureGroup

function __ScribbleTextureGroupGetReady(_textureGroup)
{
    return ((_textureGroup == undefined)
         || (texturegroup_get_status(_textureGroup) == texturegroup_status_loaded)
         || (texturegroup_get_status(_textureGroup) == texturegroup_status_fetched));
}