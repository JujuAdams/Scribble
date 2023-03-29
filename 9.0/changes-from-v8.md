# Changes from Scribble 8

&nbsp;

Scribble 9 introduces a number of new features alongside a small number of breaking changes. This page will help you make the jump.

&nbsp;

## New Features

- Adds support for SDF fonts
- Adds `.font()` and `.colour()`
- Adds `.layout_scroll()` and `.layout_scroll_split_pages()`
- Adds support for dynamic fonts via `scribble_font_add()` which works similarly to `font_add()`
- Adds `scribble_font_delete()` to manage memory for the above
- Adds standardised method to specific glyph ranges
- `scribble_kerning_pair_set()` can now take multiple characters
- Adds optional argument to `.ignore_command_tags()` that also strips tags
- Adds `scribble_premultiply_alpha_set/get()`
- Adds `scribble_blend_sprites_set/get()`
- Adds `[offset]` and `[/offset]`

&nbsp;

## Breaking Changes

- `.wrap()` has been replaced by `.layout_wrap()` and `.layout_wrap_split_pages()`
- `.scale_to_box()` has been replaced by `.layout_scale()`
- `.fit_to_box()` has been replaced by `.layout_fit()`
- `.pin_guide_width()` has been replaced by `.layout_guide()`
- `.transform()` has been replaced by `.post_transform()`
- `scribble_glyph_set()` and `scribble_glyph_get()` have been replaced by property-specific functions
- `scribble_msdf_thickness_offset()` has been replaced by `scribble_sdf_thickness_offset()` as part of the change away from MSDF fonts to SDF fonts
- `.flash()` has been replaced by `.rgb_lerp()`
- `.blend()` has been replaced by `.rgb_multiply()`

&nbsp;

## Removed Features

- `__scribble_config_colours()` has been removed. Please add custom colours using `scribble_color_set()`
- `.starting_format()` has been removed and replaced by `.font()` and `.colour()`
- MSDF fonts have been removed and replaced by SDF fonts
- `scribble_super_glyph_delete()` has been removed
- All legacy v7 typewriter text element methods have been removed
- Because Scribble no longer needs to load external files for MSDF fonts, `SCRIBBLE_INCLUDED_FILES_SUBDIRECTORY` has been removed
- `SCRIBBLE_SPRITEFONT_LEGACY_HEIGHT` has been removed
- `SCRIBBLE_FLUSH_RETURNS_SELF` has been removed