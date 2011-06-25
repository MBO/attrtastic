require "active_support"

module Attrtastic
  class SemanticAttributesBuilder

    # Only for testing purposes
    attr_reader :record, :template

    # For compatibility with formtastic
    alias :object :record

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
    #   @option options [String] :name (nil) Optional header of attributes section
    #   @option options [String] :class ('') Name of html class to add to attributes block
    #   @option options [String] :header_class ('') Name of html class to add to header
    #   @yield Block which can call #attribute to include attribute value
    #
    #   @example
    #     <%= attr.attributes do %>
    #       <%= attr.attribute :name %>
    #       <%= attr.attribute :email %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes :name => "User" do %>
    #       <%= attr.attribute :name %>
    #       <%= attr.attribute :email %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes :for => :user do |user| %>
    #       <%= user.attribute :name %>
    #       <%= user.attribute :email %>
    #       <%= user.attribute :profile do %>
    #         <%= link_to h(user.record.name), user_path(user.record) %>
    #       <% end %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes :for => @user do |user| %>
    #       <%= user.attribute :name %>
    #       <%= user.attribute :email %>
    #       <%= user.attribute :profile do %>
    #         <%= link_to h(@user.name), user_path(@user) %>
    #       <% end %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes :for => :posts do |post| %>
    #       <%= post.attribute :author %>
    #       <%= post.attribute :title %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes :for => @posts do |post| %>
    #       <%= post.attribute :author %>
    #       <%= post.attribute :title %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes :for => @posts do |post| %>
    #       <%= post.attribute :birthday, :format => false %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes :for => @posts do |post| %>
    #       <%= post.attribute :birthday, :format => :my_fancy_birthday_formatter %>
    #     <% end %>
    #
    # @overload attributes(header, options = {}, &block)
    #   Creates attributes list with header and yields block to include each attribute
    #
    #   @param [String] header Header of attributes section
    #   @param [Hash] options Options for formating attributes block
    #   @option options [String] :class ('') Name of html class to add to attributes block
    #   @option options [String] :header_class ('') Name of html class to add to header
    #   @option optinos [Symbol,Object] :for Optional new record for new builder
    #     passed as argument block. This new record can be symbol of method name for actual
    #     record, or any other object which is passed as new record for builder.
    #   @yield Block which can call #attribute to include attribute value
    #   @yieldparam builder Builder instance holding actual record (retivable via #record)
    #
    #   @example
    #     <%= attr.attributes "User info" do %>
    #       <%= attr.attribute :name" %>
    #       <%= attr.attribute :email %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes "User", :for => :user do |user| %>
    #       <%= user.attribute :name %>
    #       <%= user.attribute :email %>
    #       <%= user.attribute :profile do %>
    #         <%= link_to h(user.record.name), user_path(user.record) %>
    #       <%  end %>
    #     <% end %>
    #
    #   @example
    #     <% attr.attributes "User", :for => @user do |user| %>
    #       <%= user.attribute :name %>
    #       <%= user.attribute :email %>
    #       <%= user.attribute :profile do %>
    #         <%= link_to h(@user.name), user_path(@user) %>
    #       <% end %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes "Post", :for => :posts do |post| %>
    #       <%= post.attribute :author %>
    #       <%= post.attribute :title %>
    #     <% end %>
    #
    #   @example
    #     <%= attr.attributes "Post", :for => @posts do |post| %>
    #       <%= post.attribute :author %>
    #       <%= post.attribute :title %>
    #     <% end %>
    #
    # @overload attributes(*symbols, options = {})
    #   Creates attributes list without header, attributes are given as list of symbols (record properties)
    #
    #   @param [Symbol, ...] symbols List of attributes
    #   @param [Hash] options Options for formating attributes block
    #   @option options [String] :name (nil) Optional header of attributes section
    #   @option options [String] :class ('') Name of html class to add to attributes block
    #   @option options [String] :header_class ('') Name of html class to add to header
    #
    #   @example
    #     <%= attr.attributes :name, :email %>
    #
    #   @example
    #     <%= attr.attributes :name, :email, :for => :author %>
    #
    #   @example
    #     <%= attr.attributes :name, :email, :for => @user %>
    #
    #   @example
    #     <%= attr.attributes :title, :for => :posts %>
    #
    #   @example
    #     <%= attr.attributes :title, :for => @posts %>
    #
    # @overload attributes(header, *symbols, options = {})
    #   Creates attributes list with header, attributes are given as list of symbols (record properties)
    #
    #   @param [String] header Header of attributes section
    #   @param [Symbol, ...] symbols Optional list of attributes
    #   @param [Hash] options Options for formating attributes block
    #   @option options [String] :class ('') Name of html class to add to attributes block
    #   @option options [String] :header_class ('') Name of html class to add to header
    #
    #   @example
    #     <%= attr.attributes "User info" :name, :email %>
    #
    #   @example
    #     <%= attr.attributes "Author", :name, :email, :for => :author %>
    #
    #   @example
    #     <%= attr.attributes "Author", :name, :email, :for => @user %>
    #
    #   @example
    #     <%= attr.attributes "Post", :title, :for => :posts %>
    #
    #   @example
    #     <%= attr.attributes "Post", :title, :for => @posts %>
    #
    # @example All together
    #   <%= attr.attributes "User info", :name, :email, :class => "user_info", :header_class => "header important" %>
    #
    # @example With block
    #   <%= attr.attributes "User info" :class => "user_info", :header_class => "header important" do %>
    #     <%= attr.attribute :name %>
    #     <%= attr.attribute :email %>
    #   <% end %>
    #
    # @see #attribute
    def attributes(*args, &block)
      options = args.extract_options!
      options[:html] ||= {}

      if args.first and args.first.is_a? String
        options[:name] = args.shift
      end

      if options[:for].blank?
        attributes_for(record, args, options, &block)
      else
        for_value = if options[:for].is_a? Symbol
          record.send(options[:for])
        else
          options[:for]
        end

        [*for_value].map do |value|
          value_options = options.clone
          value_options[:html][:class] = [ options[:html][:class], value.class.to_s.underscore ].compact.join(" ")

          attributes_for(value, args, options, &block)
        end.join.html_safe
      end

    end

    ##
    # Creates list entry for single record attribute
    #
    # @overload attribute(method, options = {})
    #   Creates entry for record attribute
    #
    #   @param [Symbol] method Attribute name of given record
    #   @param [Hash] options Options
    #   @option options [Hash] :html ({}) Hash with optional :class, :label_class and :value_class names of class for html
    #   @option options [String] :label Label for attribute entry, overrides default label name from symbol
    #   @option options [Symbol,Object] :value If it's Symbol, then it's used as either name of hash key to use on attribute
    #           (if it's hash) or method name to call on attribute. Otherwise it's used as value to use instead of
    #           actual attribute's.
    #   @option options [Boolean] :display_empty (false) Indicates if print value of given attribute even if it is blank?
    #   @option options [Symbol,false,nil] :format (nil) Type of formatter to use to display attribute's value. If it's false,
    #           then don't format at all (just call #to_s). If it's nil, then use default formatting (#l for dates,
    #           #number_with_precision/#number_with_delimiter for floats/integers). If it's Symbol, then use it to select
    #           view helper method and pass aattribute's value to it to format.
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
    #   @example
    #     <%= attr.attribute :address, :value => :street %>
    #
    #   @example
    #     <%= attr.attribute :avatar, :value => :url, :format => :image_tag %>
    #
    # @overload attribute(method, options = {}, &block)
    #   Creates entry for attribute given with block
    #
    #   @param [Symbol] method Attribute name of given record
    #   @param [Hash] options Options
    #   @option options [Hash] :html ({}) Hash with optional :class, :label_class and :value_class names of classes for html
    #   @option options [String] :label Label for attribute entry, overrides default label name from symbol
    #   @yield Block which is executed in place of value for attribute
    #
    #   @example
    #     <%= attr.attribute :name do %>
    #       <%= link_to @user.full_name, user_path(@user) %>
    #
    # @overload attribute(options = {}, &block)
    #   Creates entry for attribute with given block, options[:label] is mandatory in this case.
    #
    #   @param [:Hash] options Options
    #   @option options [Hash] :html ({}) Hash with optional :class, :label_class and :value_class names of classes for html
    #   @option options [String] :label Mandatory label for attribute entry
    #   @yield Block which is executed in place of value for attribute
    #
    #   @example
    #     <%= attr.attribute :label => "User link" do %>
    #       <%= link_to @user.full_name, user_path(@user) %>
    #
    # @example
    #   <%= attr.attribute :name, :display_empty => true %>
    #
    # @example
    #   <%= attr.attribute :label => "User link" do %>
    #     <%= link_to @user.full_name, user_path(@user) %>
    #
    def attribute(*args, &block)
      options = args.extract_options!
      options[:html] ||= {}

      method = args.shift

      html_label_class = [ "label", options[:html][:label_class] ].compact.join(" ")
      html_value_class = [ "value", options[:html][:value_class] ].compact.join(" ")
      html_class = [ "attribute", options[:html][:class] ].compact.join(" ")

      label = options.key?(:label) ? options[:label] : label_for_attribute(method)

      unless block_given?
        value = if options.key?(:value)
          case options[:value]
            when Symbol
              attribute_value = value_of_attribute(method)
              case attribute_value
                when Hash
                  attribute_value[options[:value]]
                else
                  attribute_value.send(options[:value])
              end
            else
              options[:value]
          end
        else
          value_of_attribute(method)
        end

        value = case options[:format]
          when false
            value
          when nil
            format_attribute_value(value)
          else
            template.send(options[:format], value)
        end

        if value.present? or options[:display_empty]
          output = template.tag(:li, {:class => html_class}, true)
          output << template.content_tag(:span, label, :class => html_label_class)
          output << template.content_tag(:span, value, :class => html_value_class)
          output.safe_concat("</li>")
        end
      else
        output = template.tag(:li, {:class => html_class}, true)
        output << template.content_tag(:span, label, :class => html_label_class)
        output << template.tag(:span, {:class => html_value_class}, true)
        output << template.capture(&block)
        output.safe_concat("</span>")
        output.safe_concat("</li>")
      end
    end

    private

    def attributes_for(object, methods, options, &block)
      new_builder = self.class.new(object, template)

      html_class = [ "attributes", options[:html].delete(:class) ].compact.join(" ")
      html_header_class = [ "legend", options[:html].delete(:header_class) ].compact.join(" ")

      output = template.tag(:div, {:class => html_class}, true)

      header = options[:name]

      if header.present?
        output << template.content_tag(:div, :class => html_header_class) do
          template.content_tag(:span, header)
        end
      end

      if block_given?
        output << template.tag(:ol, {}, true)
        output << template.capture(new_builder, &block)
        output.safe_concat("</ol>")
      elsif methods.present?
        output << template.tag(:ol, {}, true)
        methods.each do |method|
          output << new_builder.attribute(method, options)
        end
        output.safe_concat("</ol>")
      end

      output.safe_concat("</div>")
    end

    def label_for_attribute(method)
      if record.class.respond_to?(:human_attribute_name)
        record.class.human_attribute_name(method.to_s)
      else
        method.to_s.send(:humanize)
      end
    end

    def value_of_attribute(method)
      record.send(method)
    end

    def format_attribute_value(value)
      case value
        when Date, Time, DateTime
          template.send(:l, value)
        when Integer
          template.send(:number_with_delimiter, value)
        when Float, BigDecimal
          template.send(:number_with_precision, value)
        else
          value.to_s
      end
    end
  end
end
