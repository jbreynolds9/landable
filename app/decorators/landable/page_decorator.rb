module Landable
  class PageDecorator
    include ActionView::Helpers::TagHelper

    def initialize(page)
      raise TypeError.new("Use Landable::NullPageDecorator") if page.nil?
      @page = page
    end

    def title
      content_tag('title', page.title) if page.title?
    end

    def path
      page.path
    end

    def body
      page.body.try(:html_safe)
    end

    def head_content
      page.head_content.try(:html_safe)
    end

    def meta_tags
      return unless tags = page.meta_tags
      Rails.logger.info "Meta tags string: #{tags}" if tags.is_a? String
      return if tags.empty? or !tags.is_a? Hash

      tags.map { |name, value|
        tag('meta', name: name, content: value) if value.present?
      }.compact.join("\n").html_safe
    end

    private

    attr_reader :page # Keeping it private until there's a compelling reason not to
  end
end
