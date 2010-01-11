##
# Attrtastic, in its assumption, should be similar to formtastic and
# ease displaying AR informations, help create scaffolded show and index
# pages.
#
# @author Boruta Mirosław
module Attrtastic

  class SemanticAttributesBuilder

    # Only for testing purposes
    attr_reader :record, :template

    def initialize(record, template)
      @record, @template = record, template
    end

    ##
    # Creates block of attributes with optional header. Attributes are surrounded with ordered list.
    #
    # @overload attributes(options = {}, &block)
    #   Creates attributes list without header, yields block to include each attribute
    #
    #   @param [Hash] options Options for formating attributes block
    #   @option options [String] :class ('') Name of html class(-es) to add to attributes block
    #   @option options [String] :header_class ('') Name of html class(-es) to add to header
    #   @yield Block which can call #attribute to include attribute value
    #
    #   @example
    #     <% attr.attributes do %>
    #       <%= attr.attribute :name %>
    #       <%= attr.attribute :email %>
    #     <% end %>
    #
    # @overload attributes(header, options = {}, &block)
    #   Creates attributes list with header and yields block to include each attribute
    #
    #   @param [String] header Header of attributes section
    #   @param [Hash] options Options for formating attributes block
    #   @option options [String] :class ('') Name of html class(-es) to add to attributes block
    #   @option options [String] :header_class ('') Name of html class(-es) to add to header
    #   @yield Block which can call #attribute to include attribute value
    #
    #   @example
    #     <% attr.attributes "User info" do %>
    #       <%= attr.attribute :name" %>
    #       <%= attr.attribute :email %>
    #     <% end %>
    #
    # @overload attributes(*symbols, options = {})
    #   Creates attributes list without header, attributes are given as list of symbols (record properties)
    #
    #   @param [Symbol, ...] symbols List of attributes
    #   @param [Hash] options Options for formating attributes block
    #   @option options [String] :class ('') Name of html class(-es) to add to attributes block
    #   @option options [String] :header_class ('') Name of html class(-es) to add to header
    #
    #   @example
    #     <% attr.attributes :name, :email %>
    #
    # @overload attributes(header, *symbols, options = {})
    #   Creates attributes list with header, attributes are given as list of symbols (record properties)
    #
    #   @param [String] header Header of attributes section
    #   @param [Symbol, ...] symbols Optional list of attributes
    #   @param [Hash] options Options for formating attributes block
    #   @option options [String] :class ('') Name of html class(-es) to add to attributes block
    #   @option options [String] :header_class ('') Name of html class(-es) to add to header
    #
    #   @example
    #     <% attr.attributes "User info" :name, :email %>
    #
    # @example All together
    #   <% attr.attributes "User info", :name, :email, :class => "user_info", :header_class => "header important" %>
    #
    # @example With block
    #   <% attr.attributes "User info" :class => "user_info", :header_class => "header important" do %>
    #     <%= attr.attribute :name %>
    #     <%= attr.attribute :email %>
    #   <% end %>
    #
    # @see #attribute
    def attributes(*args, &block)
      options = {}
      if args.last and args.last.kind_of? Hash
        options = args.last
        args = args[0 .. -2]
      end
      options[:html] ||= {}

      html_class = [ "attributes", options[:html].delete(:class) ].compact.join(" ")
      html_header_class = [ "legend", options[:html].delete(:header_class) ].compact.join(" ")

      template.concat(template.tag(:div, {:class => html_class}, true))

      if args.first and args.first.is_a? String
        header = args.shift
        template.concat(template.content_tag(:div, header, :class => html_header_class))
      end

      if block_given?
        template.concat(template.tag(:ol, {}, true))
        yield
        template.concat("</ol>")
      elsif args.present?
        template.concat(template.tag(:ol, {}, true))
        attrs = args.map {|method| attribute(method, options)}.compact.join
        template.concat(attrs)
        template.concat("</ol>")
      end

      template.concat("</div>")
    end

    ##
    # Creates list entry for single record attribute
    #
    # @overload attribute(method, options = {})
    #   Creates entry for record attribute
    #
    #   @param [Symbol] method Attribute name of given record
    #   @param [Hash] options Options
    #   @option options [String] :html ({}) Hash with optional :class, :label_class and :value_class names of class for html
    #   @option options [String] :label Label for attribute entry, overrides default label name from symbol
    #   @option options [String] :value Value of attribute entry, overrides default value from record
    #   @option options [Boolean] :display_empty (false) Indicates if print value of given attribute even if it is blank?
    #
    #   @example
    #     <%= attr.attribute :name %>
    #
    #   @example
    #     <%= attr.attribute :name, :label => "Full user name" %>
    #
    #   @example
    #     <%= attr.attribute :name, :value => @user.full_name %>
    #
    # @overload attribute(method, options = {}, &block)
    #   Creates entry for attribute given with block
    #
    #   @param [Symbol] method Attribute name of given record
    #   @param [Hash] options Options
    #   @option options [String] :html ({}) Hahs with optional :class, :label_class and :value_class names of class for html
    #   @option options [String] :label Label for attribute entry, overrides default label name from symbol
    #   @option options [Boolean] :display_empty (false) Indicates if print value of given attribute even if it is blank?
    #   @yield Block which is executed in place of value for attribute
    #
    #   @example
    #     <% attr.attribute :name do %>
    #       <%= link_to @user.full_name, user_path(@user) %>
    #
    #   @example
    #     <% attr.attribute :name, :label => "User link" do %>
    #       <%= link_to @user.full_name, user_path(@user) %>
    #
    # @example
    #   <%= attr.attribute :name, :display_empty => true %>
    #
    # @example
    #   <% attr.attribute :label => "User link" do %>
    #     <%= link_to @user.full_name, user_path(@user) %>
    #
    def attribute(*args, &block)
      options = {}
      if args.last and args.last.kind_of? Hash
        options = args.last
        args = args[0 .. -2]
      end
      options[:html] ||= {}

      method = args.shift

      html_label_class = [ "label", options[:html][:label_class] ].compact.join(" ")
      html_value_class = [ "value", options[:html][:value_class] ].compact.join(" ")
      html_class = [ "attribute", options[:html][:class] ].compact.join(" ")

      label = options.key?(:label) ? options[:label] : label_for_attribute(method)
      label_content = template.content_tag(:span, label, :class => html_label_class)

      unless block_given?
        value = options.key?(:value) ? options[:value] : value_of_attribute(method)
        value_content = template.content_tag(:span, value, :class => html_value_class)

        if value.present? or options[:display_empty]
          content = [ label_content, value_content ].join
          template.content_tag(:li, content, :class => html_class)
        end
      else
        template.concat(template.tag(:li, {:class => html_class}, true))
        template.concat(label_content)
        template.concat(template.tag(:span, {:class => html_value_class}, true))
        yield
        template.concat("</span>")
        template.concat("</li>")
      end
    end

    private

    def label_for_attribute(method)
      if record.class.respond_to?(:human_attribute_name)
        record.class.human_attribute_name(method.to_s)
      else
        method.to_s.send(:humanize)
      end
    end

    #@@value_methods = %w/ to_label display_name full_name name title username login value to_s /
    def value_of_attribute(method)
      record.send(method).to_s
    end

  end

  ##
  # Helper which should be included in ActionView. Adds #semantic_attributes_for
  # method, which helps printing attributes for given record, similar to
  # formtastic's sematnic_form_for
  #
  # @example
  #   ActionView::Base.send :include, Attrtastic::SemanticAttributesHelper
  #
  # @example Example of useage
  #   <% semantic_attributes_for @user do |attr| %>
  #     <% attr.attributes "User info" do %>
  #       <%= attr.attribute :name %>
  #       <%= attr.attribute :email %>
  #     <% end %>
  #     <% attr.attributes "User details" do %>
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
    #   <% semantic_attributes_for @user do |attr| %>
    #     <% attr.attributes do %>
    #       <%= attr.attribute :name %>
    #       <%= attr.attribute :email %>
    #     <% end %>
    #   <% end %>
    #
    def semantic_attributes_for(record, options = {}, &block)
      options[:html] ||= {}

      html_class = [ "attrtastic", record.class.to_s.underscore, options[:html][:class] ].compact.join(" ")

      concat(tag(:div, { :class => html_class}, true))
      yield SemanticAttributesBuilder.new(record, self) if block_given?
      concat("</div>")
    end

  end

end

