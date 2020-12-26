
Render with Substitution
=================================

To render with substitution set the global g_data before the render call (preXXXX call)

Given a template in the ./mt directory named Lesson.html there will be a function generated
`renderLesson`.  This can be called to render the form.

You can set a global g_data with a dictionary of values before hand to substitute into the
template.


```
	window.g_data = { "lesson_title": "A Title" };
	renderLesson();
```


