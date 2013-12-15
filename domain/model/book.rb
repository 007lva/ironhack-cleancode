require 'mongoid/document'
class Book
  include Mongoid::Document
  field :author, type: String
  field :title, type: String
  field :published_at, type: DateTime
  field :synopsis, type: String

  belongs_to :owner, class_name: 'User'

  def self.from_params(params)
    instance = self.new()
    instance.author = params['author']
    instance.title = params['title']
    instance.published_at = DateTime.new(Integer(params['year'])) if params['year']
    instance.published_at = DateTime.iso8601(params['publish_date']) if params['publish_date']
    instance.owner = params['owner']
    instance
  end

  def to_hash
    {id: _id, title: title, author: author, publish_date:published_at.iso8601}
  end

  def author=(new_author)
    valid_author!(new_author)
    super
  end

  def valid_author!(author)
    raise "Invalid Author #{author}" if author.length < 3 || author.length > 30
  end

  def title=(new_title)
    valid_title!(new_title)
    super
  end

  def valid_title!(title)
    raise "Invalid Title #{title}" if title.length < 3 || title.length > 30
  end

  def published_at=(new_date)
    valid_publish_date!(new_date)
    super
  end

  def valid_publish_date!(date)
    raise 'Future dates are not allowed' if DateTime.now < date
  end
end
