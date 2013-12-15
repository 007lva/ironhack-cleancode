require 'mongoid/document'
class User
  include Mongoid::Document
  field :name, type: String
  field :last_name, type: String
  field :api_key, type: String

  has_many :books, class_name: 'Book', inverse_of: :owner
end