# nestive-rails

This gem is a continuation for Rails 5 of the [nestive](https://github.com/rwz/nestive) gem originally created by Justin French and Pavel Pravosud.

nestive-rails adds powerful layout and view helpers to your Rails app. It's similar to the nested layout technique [already documented in the Rails guides](http://guides.rubyonrails.org/layouts_and_rendering.html#using-nested-layouts) and found in many other nested layout plugins (a technique using `content_for` and rendering the parent layout at the end of the child layout). There's a bunch of problems with this technique, including:

* you can only *append* content to the content buffer with `content_for` (you can't prepend to content, you can't replace it)
* when combined with this nested layout technique, `content_for` actually *prepends* new content to the buffer, because each parent layout is rendered *after* it's child

nestive-rails is *better* because it addresses these problems.

---

## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
  * [Declaring an area of content with `area`](#declaring-an-area-of-content-with-area)
  * [Appending content to an area with `append`](#appending-content-to-an-area-with-append)
  * [Prepending content to an area with `prepend`](#prepending-content-to-an-area-with-prepend)
  * [Replacing content with `replace`](#replacing-content-with-replace)
  * [Removing content with `purge`](#removing-content-with-purge)
  * [Extending a layout in a child layout (or view) with `extends`](#extending-a-layout-in-a-child-layout-or-view-with-extends)
* [Example](#example)
* [Caching](#caching)
* [Testing](#testing)
* [Release](#release)
* [To Do](#to-do)
* [Contributing](#contributing)
  * [Semantic versioning](#semantic-versioning)

---

## Installation

`nestive-rails` works with Rails 5.0 onwards. You can add it to your `Gemfile` with:

```ruby
gem 'nestive-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nestive-rails

If you always want to be up to date fetch the latest from GitHub in your `Gemfile`:

```ruby
gem 'nestive-rails', github: 'jonhue/nestive-rails'
```

## Usage

### Declaring an area of content with `area`

The `area` helper is a lot like Rails' own `<%= yield :foo %>`, and is used in layouts to define and render a chunk of content in your layout:

```erb
<%= area :sidebar %>
```

Unlike `yield`, `area` will allow your parent layouts to add content to the area at the same time using either a String or a block:

```erb
<%= area :sidebar, "Some Content Here" %>

<%= area :sidebar do %>
  Some Content Here
<% end %>
```

It's important to note that this isn't *default* content, it *is* the content (unless a child changes it).

### Appending content to an area with `append`

The implementation details are quite different, but the `append` helper works much like Rails' built-in `content_for`. It will work with either a String or block, adding the new content onto the end of any content previously provided by parent layouts:

```erb
<%= extends :application do %>
  <% append :sidebar, "More content." %>
  <% append :sidebar do %>
    More content.
  <% end %>
<% end %>
```

### Prepending content to an area with `prepend`

Exactly what you think it is. The reverse of `append` (duh), adding the new content at the start of any content previously provided by parent layouts:

``` erb
<%= extends :application do %>
  <%= prepend :sidebar, "Content." %>
  <%= prepend :sidebar do %>
    Content.
  <% end %>
<% end %>
```

### Replacing content with `replace`

You can also replace any content provided by parent layouts:

``` erb
<%= extends :application do %>
  <%= replace :sidebar, "New content." %>
  <%= replace :sidebar do %>
    New content.
  <% end %>
<% end %>
```

### Removing content with `purge`

You can remove the content in the single or in multiple areas

``` erb
<% purge :sidebar %>
<% purge :sidebar, :banner %>
```

... which is equal to:

``` erb
<% replace :sidebar, nil %>
```

### Extending a layout in a child layout (or view) with `extends`

Any layout (or view) can declare that it wants to inherit from and extend a parent layout, in this case we're extending `app/views/layouts/application.html.erb`:

``` erb
<%= extends :application do %>
 ...
<% end %>
```

You can nest many levels deep:

`app/views/layouts/application.html.erb`:

``` erb
<!DOCTYPE html>
<html>
  <head>
    <%= area :head do %>
      <title><%= area :title, 'Nestive' %></title>
    <% end %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

`app/views/layouts/with_sidebar.html.erb`:

``` erb
<%= extends :application do %>
  <div class="sidebar"><%= area(:sidebar) do %>
    here goes sidebar
  <% end %></div>
  <%= yield -%>
<% end %>
```

`app/views/layouts/blog_posts.html.erb`:

``` erb
<%= extends :with_sidebar do %>
  <% append :sidebar do %>
    Blog archive:
    <%= render_blog_archive %>
  <% end %>

  <% append :head do %>
    <%= javascript_include_tag 'fancy_blog_archive_tag_cloud' %>
  <% end %>

  <%= yield %>
<% end %>
```

---

## Example

Set-up a global layout defining some content areas.

`app/views/layouts/application.html.erb`:

``` erb
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title><%= area :title, "JustinFrench.com" %></title>
    <meta name="description" content="<%= area :description, "This is my website." %>">
    <meta name="keywords" content="<%= area :keywords, "justin, french, ruby, design" %>">
  </head>
  <body>
    <div id="wrapper">
      <div id="content">
        <%= area :content do %>
          <p>Default content goes here.</p>
        <% end %>
      </div>
      <div id="sidebar">
        <%= area :sidebar do %>
          <h2>About Me</h2>
          <p>...</p>
        <% end %>
      </div>
    </div>
    <%= yield %>
  </body>
</html>
```

Next, we set-up a `blog` layout that extends `application`, replacing,
appending & prepending content to the areas we defined earlier.

`app/views/layouts/blog.html.erb`:

``` erb
<%= extends :application do %>
  <% replace :title, "My Blog ??? " %>
  <% replace :description, "Justin French blogs here on Ruby, Rails, Design, Formtastic, etc" %>
  <% prepend :keywords, "blog, weblog, design links, ruby links, formtastic release notes, " %>
  <%= yield %>
<% end %>
```

Now in our blog index view we can use `blog` layout and fill in the areas with
content specific to the index action.


`app/views/posts/index.html.erb`:

``` erb
<% replace :content do %>
  <h1>My Blog</h1>
  <%= render @articles %>
<% end %>

<% append :sidebar do %>
  <h2>Blog Roll</h2>
  <%= render @links %>
<% end %>
```

We also need to instruct the `PostsController` to use this `blog` layout:

`app/controllers/posts_controller.rb`:

``` ruby
class PostsController < ApplicationController
  layout 'blog'
end
```

---

## Caching

nestive-rails works the same way `content_for` does and has the same caching drawbacks. That means that nestive-rails helpers are completely ignored when called from within cached block. You probably don't want to use fragment caching around dynamic nestive-rails areas and have to be extra careful what and how you cache to avoid unpleasant surprises.

---

## Testing

1. Fork this repository
2. Clone your forked git locally
3. Install dependencies

    `$ bundle install`

4. Run tests

    `$ bundle exec rspec`

5. Run RuboCop

    `$ bundle exec rubocop`

---

## Release

1. Review breaking changes and deprecations in `CHANGELOG.md`
2. Change the gem version in `lib/nestive-rails/version.rb`
3. Reset `CHANGELOG.md`
4. Create a pull request to merge the changes into `master`
5. After the pull request was merged, create a new release listing the breaking changes and commits on `master` since the last release.
6. The release workflow will publish the gems to RubyGems and the GitHub Package Registry

---

## Contributing

We hope that you will consider contributing to nestive-rails. Please read this short overview for some information about how to get started:

[Learn more about contributing to this repository](https://github.com/jonhue/nestive-rails/blob/master/CONTRIBUTING.md), [Code of Conduct](https://github.com/jonhue/nestive-rails/blob/master/CODE_OF_CONDUCT.md)

### Semantic Versioning

nestive-rails follows Semantic Versioning 2.0 as defined at http://semver.org.
