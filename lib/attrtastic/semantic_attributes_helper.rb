module Attrtastic
  ##
  # Helper which should be included in ActionView. Adds #semantic_attributes_for
  # method, which helps printing attributes for given record, similar to
  # formtastic's sematnic_form_for
  #
  # @example
  #   ActionView::Base.send :include, Attrtastic::SemanticAttributesHelper
  #
  # @example Example of useage
  #   <%= semantic_attributes_for @user do |attr| %>
  #     <%= attr.attributes "User info" do %>
  #       <%= attr.attribute :name %>
  #       <%= attr.attribute :email %>
  #     <% end %>
  #     <%= attr.attributes "User details" do %>
  #       <%= attr.attribute :weight %>
  #       <%= attr.attribute :height %>
  #       <%= attr.attribute :age %>
  #     <% end %>
  #   <% end %>
  module SemanticAttributesHelper

    ##
    # Creates attributes for given object
    #
    # @param[ActiveRecord] record AR instance record for which to display attributes
    # @param[Hash] options Opions
    # @option options [Hash] :html ({}) Hash with optional :class html class name for html block
    # @yield [attr] Block which is yield inside of markup
    # @yieldparam [SemanticAttributesBuilder] builder Builder for attributes for given AR record
    #
    # @example
    #   <%= semantic_attributes_for @user do |attr| %>
    #     <%= attr.attributes do %>
    #       <%= attr.attribute :name %>
    #       <%= attr.attribute :email %>
    #     <% end %>
    #   <% end %>
    #
    def semantic_attributes_for(record, options = {}, &block)
      options[:html] ||= {}

      html_class = [ "attrtastic", record.class.to_s.underscore, options[:html][:class] ].compact.join(" ")

      output = tag(:div, { :class => html_class}, true)
      if block_given?
        output << capture(SemanticAttributesBuilder.new(record, self), &block)
      end
      output.safe_concat("</div>")
    end

  end
end

