# Changes from Scribble 8

&nbsp;

Scribble 9 introduces a number of new features alongside a small number of breaking changes. This page will help you make the jump.

&nbsp;

## New Features

- Adds support for SDF fonts
- Adds support for dynamic fonts via `font_add()`
- Adds `.font()` and `.colour()`
- `.layout_scroll()` and `.layout_scroll_split_pages()`

&nbsp;

## Breaking Changes

- `.wrap()` has been replaced by `.layout_wrap()` and `.layout_wrap_split_pages()`
- `.scale_to_box()` has been replaced by `.layout_scale()`
- `.fit_to_box()` has been replaced by `.layout_fit()`

&nbsp;

## Removed Features

- `.starting_format()` has been removed and replaced by `.font()` and `.colour()`
- MSDF fonts have been removed and replaced by SDF fonts