# TODOs

## 2019-08-12_0710 Per route page titles

  [This SO thread](https://stackoverflow.com/questions/42362376/phoenix-framework-page-titles-per-route)
  is the  answer, but it  requires the per  route page
  titles to be  set in the view modules.  I would like
  all of them to be in the same place (easier to check
  for consistency, and better than editing 27 files if
  something changes).

  **Idea 1**:  create a `page_titles.ex` that  will be
  used in `anv_web.ex` to dynamically make a `title/?`
  function  in each  view. Didn't  have time  to think
  this through  deeper, but basically there  will be a
  map  with view  modules  as keys  and  the title  as
  value,  and `__using__/2`  will create  the function
  according to which view module it is called.

  **Idea 2**:  Can **Idea  1** be  done in  the router
  somehow?

  The rest should be the same as in the SO answer.
