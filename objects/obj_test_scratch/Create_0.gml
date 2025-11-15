// Feather disable all

testString = "textstart\ntext\ntext\ntext\ntext\ntext\ntext\ntext\ntext\ntextend";

element = scribble_unique(testString)
          .max_size(107, 107)
          .clip()
          .align(fa_center, fa_middle)
          .scroll_auto();