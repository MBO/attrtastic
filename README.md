# Attrtastic

Attrtastic is simple view helper which can be used to create index/show pages
for any objects (for example Active Model objects). It helps you display
all present attributes of object.

If you need compatibility with Rails 2.x, then please install version 0.2.2 of
this gem.

## Using

Install the gem:

    gem install attrtastic

Add to your `Gemfile`:

    gem "attrtastic"

And use in your views, for example in user/show.erb

    <%= semantic_attributes_for @user do |attr| %>
      <%= attr.attributes "User" do %>
        <%= attr.attribute :first_name %>
        <%= attr.attribute :last_name %>
        <%= attr.attribute :avatar do %>
          <%= image_tag @user.avatar.url %>
        <% end %>
      <% end %>
      <%= attr.attributes "Contact" do %>
        <%= attr.attribute :email %>
        <%= attr.attribute :tel %>
        <%= attr.attribute :fax %>
      <% end %>
    <% end %>

By default attributes which returns `#blank?` value are ommited, unless
`:display_empty => true` is added to `#attribute`.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009-2011 Boruta Mirosław. See LICENSE for details.
