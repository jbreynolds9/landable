module Landable
  class CategorySerializer < ActiveModel::Serializer
    attributes :id, :name, :description
  end
end
