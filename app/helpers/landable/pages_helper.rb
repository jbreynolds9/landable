module Landable
  module PagesHelper
    def landable(page = current_page)
      return Landable::NullPageDecorator.new if page.nil?
      @landable ||= Landable::PageDecorator.new(page)
    end

    def current_page
      @current_page ||= Page.by_path(request.path)
    end
  end
end
