require 'mongoid/document'
class User
  include Mongoid::Document
  field :name, type: String
  field :last_name, type: String
  field :api_key, type: String

  has_many :books, class_name: 'Book', inverse_of: :owner

  def self.from_params(params)
    instance = self.new
    instance.name = params['name']
    instance.last_name = params['last_name']
    instance
  end

  def self.generate_api_key
    "A-#{([nil]*8).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join}"
  end

  def name=(new_name)
    valid_name!(new_name)
    super
  end

  def valid_name!(name)
  end

  def last_name=(new_last_name)
    valid_last_name!(new_last_name)
    super
  end

  def valid_last_name!(last_name)
  end
end