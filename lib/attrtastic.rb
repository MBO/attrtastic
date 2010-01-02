module Attrtastic

  class SemanticAttributesBuilder

    @@value_methods = %w/ to_label display_name full_name name title username login value to_s /

    attr_reader :record, :template

    def initialize(record, template)
      @record, @template = record, template
    end

    def attributes(*args, &block)
      options = {}
      if args.last.kind_of? Hash
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

    def attribute(method, options = {}, &block)
      options[:html] ||= {}

      html_label_class = [ "label", options[:html][:label_class] ].compact.join(" ")
      html_value_class = [ "value", options[:html][:value_class] ].compact.join(" ")
      html_class = [ "attribute", options[:html][:class] ].compact.join(" ")

      label = options.key?(:label) ? options[:label] : label_for_attribute(method)
      label_content = template.content_tag(:span, label, :class => html_label_class)

      value = options.key?(:value) ? options[:value] : value_of_attribute(method)
      value_content = template.content_tag(:span, value, :class => html_value_class)

      if block_given?
        template.concat(template.tag(:li, {:class => html_class}, true))
        template.concat(label_content)
        template.concat(template.tag(:span, {:class => html_value_class}, true))
        yield
        template.concat("</span>")
        template.concat("</li>")
      elsif value.present? or options[:display_empty]
        content = [ label_content, value_content ].join
        template.content_tag(:li, content, :class => html_class)
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

    def value_of_attribute(method)
      record.send(method).to_s
    end

  end

  module SemanticAttributesHelper

    def semantic_attributes_for(record, options = {}, &block)
      options[:html] ||= {}

      html_class = [ "attrtastic", record.class.to_s.underscore, options[:html][:class] ].compact.join(" ")

      concat(tag(:div, { :class => html_class}, true))
      yield SemanticAttributesBuilder.new(record, self) if block_given?
      concat("</div>")
    end

  end

end

