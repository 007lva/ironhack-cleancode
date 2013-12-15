require 'mongoid/document'
class Book
  include Mongoid::Document
  field :author, type: String
  field :title, type: String
  field :published_at, type: DateTime
  field :synopsis, type: String

  belongs_to :owner, class_name: 'User'
end