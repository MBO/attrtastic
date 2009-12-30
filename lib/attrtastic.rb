module Attrtastic

  class SemanticAttributesBuilder

    @@label_str_method = :humanize
    @@value_methods = %w/ to_label display_name fill_name name title username login value to_s /

    attr_reader :record, :template

    def initialize(record, template)
      @record, @template = record, template
    end

    def attributes(&block)
      template.concat(template.tag(:ol, {}, true))
      yield
      template.concat("</ol>")
    end

    def attribute
    end

  end

  module SemanticAttributesHelper

    def semantic_attributes_for(record, options = {}, &block)
      options[:html] ||= {}

      class_names = options[:html][:class] ? options[:htlm][:class].split(" ") : []
      class_names << "attrtastic"
      class_names << record.class.to_s.underscore # @post => "post"

      concat(tag(:div, { :class => class_names.join(" ")}, true))
      yield SemanticAttributesBuilder.new(record, self) if block_given?
      concat("</div>")
    end

  end

end

