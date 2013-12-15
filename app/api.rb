require 'domain/repository/Exception/not_found'
require 'sinatra/base'
require 'dependencies/dependency_manager'
class Api < Sinatra::Base
  include DependencyManager

  def initialize(app = nil)
    super
    load_dependencies
  end

  get '/books' do
    content_type :json
    api_key = request.env['HTTP_IRONHACK_API_KEY']

    books = @book_service.find_owned_by_user_with_api_key(api_key)

    render_books_as_json(books)
  end

  get '/books/:id' do
    content_type :json
    api_key = request.env['HTTP_IRONHACK_API_KEY']
    book_id = @params[:id]

    book =  @book_service.find_by_id_owned_by_user_with_api_key(book_id, api_key)

    book.to_hash.to_json
  end

  post '/books' do
    content_type :json
    api_key = request.env['HTTP_IRONHACK_API_KEY']
    request_data = JSON.parse(request.body.read)

    book = @book_service.create_from_params_for_user_with_api_key(request_data, api_key)

    book.to_hash.to_json
  end

  error NotFound do
    raise not_found
  end

  private
  def render_books_as_json(books)
    result = []
    books.each do |book|
      result << book.to_hash
    end
    result.to_json
  end
end