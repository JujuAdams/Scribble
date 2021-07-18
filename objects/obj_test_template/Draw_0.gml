scribble("Template test").template(template_test).draw(10, 10);
scribble("Template test, but only executed on change").template(template_other_test, true).draw(10, 40);