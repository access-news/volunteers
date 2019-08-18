# TODOs

## 2019-08-17_0735 Add tests

+ https://elixirschool.com/en/lessons/basics/testing/
+ https://spin.atomicobject.com/2018/10/22/elixir-test-multiple-environments/
+ https://spin.atomicobject.com/2017/12/27/elixir-mox-introduction/
+ https://paulhoffer.com/2018/03/22/easy-session-testing-in-phoenix-and-plug.html
+ http://blog.plataformatec.com.br/2016/01/writing-acceptance-tests-in-phoenix/
+ https://semaphoreci.com/community/tutorials/end-to-end-testing-in-elixir-with-hound
+ https://semaphoreci.com/community/tutorials/introduction-to-testing-elixir-applications-with-exunit
+ https://semaphoreci.com/community/tutorials/test-driven-apis-with-phoenix-and-elixir
+ https://elixirforum.com/t/regression-testing/7565
+ https://www.google.com/search?q=acceptance+vs+integration+tests&oq=acceptance+vs+inte&aqs=chrome.0.0j69i57.4089j0j7&sourceid=chrome&ie=UTF-8
+ https://stackoverflow.com/questions/4904096/whats-the-difference-between-unit-functional-acceptance-and-integration-test

+ https://elixirforum.com/t/wallaby-vs-hound/443
+ https://github.com/HashNuke/hound
+ https://github.com/keathley/wallaby
+ https://keathley.io/elixir/wallaby/2018/08/10/wallaby-is-looking-for-new-maintainers.html

+ https://www.google.com/search?q=elixir+testing+puppeteer&oq=elixir+testing+puppeteer&aqs=chrome..69i57j69i64l2.6997j0j7&sourceid=chrome&ie=UTF-8
+ https://ropig.com/blog/end-end-tests-dont-suck-puppeteer/
+ https://hexdocs.pm/phoenix/testing_schemas.html#content
+ https://hexdocs.pm/ex_unit/ExUnit.html#content
+ https://hexdocs.pm/phoenix/Phoenix.ConnTest.html?#html_response/2

## 2019-08-18_0714 Go HTTPS

+ https://www.google.com/search?q=should+public+sites+use+https&oq=should+public+sites+use+https&aqs=chrome..69i57.8941j0j7&sourceid=chrome&ie=UTF-8
+ https://https.cio.gov/everything/
+ https://developers.google.com/web/fundamentals/security/encrypt-in-transit/why-https
+ https://www.troyhunt.com/heres-why-your-static-website-needs-https/
+ https://mashable.com/2011/05/31/https-web-security/

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

Other resources:
+ https://elixirforum.com/t/phoenix-render-a-template-that-changes-with-route/13730
+ https://elixirforum.com/t/phoenix-slug-url-primary-key-best-practices/13253

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
## 2019-08-13_0951 What to do with reserved ads on update

Shouldn't happen  though, because if the  ads aren't
read at  least a couple days  before `valid_to` than
they are kind of useless (and we would get calls way
before that).

See also NOTE 2019-08-13_0954.

## 2019-08-13_1100 Deal with re-enabled Admin Tools button

Button  is disabled  if  logged in  user  is not  an
admin, but if the `disabled` attribute is removed in
dev tools, the button can be clicked.

With  that said,  it still  won't work,  but a  nice
error message would be better than a crashed page.

## 2019-08-13_1313 Make tables prettier/more accessible/etc

+ https://developer.mozilla.org/en-US/docs/Learn/HTML/Tables/Advanced
+ https://stackoverflow.com/questions/33621173/id-and-headers-or-scope-for-data-table-accessibility

## 2019-08-13_1446 How to break out early?

This won't work because `get_user/1` returns a tuple (`{:ok, _}` or `{:error, _}`) and so is `Repo.delete/1`. What is the category theory solution for this?

```elixir
def delete_user(id) do
  id
  |> get_user()
  |> Repo.delete()
end
```
## 2019-08-13_1501 Implement signup link

The idea is to send dedicated signup links to users.
[My approach](https://stackoverflow.com/questions/57399151/how-to-craft-a-dedicated-signup-link):

  1. generate a token on the backend,

  2. hide it in the sign up form,

  3. attach a timer to the token,

  4. attach the token in a query string to a valid route,
 e.g., `http://example.com/signup?token=1020a9e4-476a-4f74-b93a-b469d225dac0`

  5. send it in an email,

  6. and when that person registers, just extract the token from the form data.

## 2019-08-16_1318 Store renaming considerations

> At  the  moment,  stores   cannot  be  renamed,  and
> updating the images is all or nothing. To rename the
> store, delete  it, and recreate it  with a different
> name. (Yes, reservation and  other metadata will get
> lost.)

Volunteer-facing            store           sections
(`page/index.html.eex`) have a unique `id` attribute
so  that   they  can   be  updated   via  Websockets
on  backend  changes.  This  ID  is  generated  from
`store_name`  (`:crypto.hash(:md5,   store_name)  |>
Base.encode16()`), and is not stored anywhere.

Renaming a store would require

1. Remove old store section  from frontend (because its
   ID will change permanently with the store name)

2. Insert the  a new  section with  new store  name and
   ID, and  corresponding data.  Basically it  would be
   handled as if the section had been loaded on initial
   page load.  That is, if  only the name  changed, the
   images will be the same, and so on.

### Change subset of images with store name change

Same as written in item  2 above: update the record,
and then re-render the section from scratch from the
DB.

## 2019-08-16_1345 create shared template (`:new` is almost the same)

There   is  a   lot   of   duplicate  code   between
`Ads`  templates  `:new`  and `:edit`,  and  between
`AdsController` functions `new/2` and `edit/2` (also
between `create/2` and `update/2`).

##
