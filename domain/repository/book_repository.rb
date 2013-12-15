require 'domain/repository/base'
require 'domain/model/book'

class BookRepository
  include Base;

  def initialize
    @model_class = Book
  end
end