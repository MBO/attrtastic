module Attrtastic

  class SemanticAttributesBuilder

    @@value_methods = %w/ to_label display_name full_name name title username login value to_s /

    attr_reader :record, :template

    def initialize(record, template)
      @record, @template = record, template
    end

    def attributes(*args, &block)
      if block_given?
        template.concat(template.tag(:div, {:class => "attributes"}, true))

        if args.first
          header = args.first
          template.concat(template.content_tag(:div, header, {:class => "legend"}))
        end

        template.concat(template.tag(:ol, {}, true))
        yield
        template.concat("</ol>")

        template.concat("</div>")
      end
    end

    def attribute(method, options = {})
      label_class = ["label"]
      value_class = ["value"]

      label = label_for_attribute(method)
      value = value_of_attribute(method)

      if value.present? or options[:display_empty]
        content = [
          template.content_tag(:span, label, {:class => label_class.join(" ")}),
          template.content_tag(:span, value,  {:class => value_class.join(" ")})
        ].join
        template.content_tag(:li, content)
      end
    end

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

      class_names = []
      class_names << options[:html][:class] if options[:html][:class]
      class_names << "attrtastic"
      class_names << record.class.to_s.underscore # @post => "post"

      concat(tag(:div, { :class => class_names.join(" ")}, true))
      yield SemanticAttributesBuilder.new(record, self) if block_given?
      concat("</div>")
    end

  end

end

