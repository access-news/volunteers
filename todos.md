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

## 2019-08-07 The `render/?`s conundrum

Understand views  and templates because  the answers
and what I  read in the docs doesn't  add up. (E.g.,
Phoenix.View.render(AppWeb.AView,   "template.html")
will fail to run)

+ https://stackoverflow.com/questions/32784008/phoenix-render-template-of-other-folder
+ https://hexdocs.pm/phoenix/views.html
+ https://hexdocs.pm/phoenix/templates.html

And  just how  many goddamn  `render` functions  are
there?   Phoenix.Controller  and   Phoenix.View  has
them,  and on  `use` there  will be  more, plus  see
before_compile  clauses as  well.  Someone else  was
having this same question:
https://stackoverflow.com/questions/43382984/difference-between-render-functions-in-phoenix

The view guide above is pretty helpful and now has a
section on  how to look into  called functions. Work
through them.

Also, figure out the connection between endpoint and
conn:
https://hexdocs.pm/phoenix/routing.html#path-helpers

```elixir
ANVWeb.Router.Helpers.user_path(ANVWeb.Endpoint, :index)
ANVWeb.Router.Helpers.user_path(@conn, :index)
```

Somewhat relevant:
https://stackoverflow.com/questions/42362376/phoenix-framework-page-titles-per-route

```elixir
#   And where is `assigns` coming from? ----------*
#                                                 |
#                                                 |
<%= if @user == nil,                            # V
      do: render(ANVWeb.SessionView, "new.html", assigns),
      else: "" %>
```
