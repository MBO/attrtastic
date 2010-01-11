# Attrtastic

Attrtastic, in its assumtion, should be similar in usage to formtastic and
ease of displaying AR record informations (attributes). It should help
scafforld show/index pages.

## Using

Install the gem:

    gem install attrtastic

Add to `config.rb` as dependency:

    config.gem 'attrtastic'

And use in your views, for example in user/show.erb

    <% semantic_attributes_for @user do |attr| %>
      <% attr.attributes "User" do %>
        <%= attr.attribute :first_name %>
        <%= attr.attribute :last_name %>
        <%  attr.attribute :avatar do %>
          <%= image_tag @user.avatar.url %>
        <%  end %>
      <% end %>
      <% attr.attributes "Contact" do %>
        <%= attr.attribute :email %>
        <%= attr.attribute :tel %>
        <%= attr.attribute :fax %>
      <% end %>
    <% end %>

By default attributes which returns #blank? value are ommited, unless
`:display_blank => true` is added to #attribute.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2009 Boruta Miroslaw. See LICENSE for details.
