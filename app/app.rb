require 'mongoid'
require 'mongoid/errors/document_not_found'
Mongoid.load!(::File.dirname(__FILE__) + "/../config/mongoid.yml")

require 'model/book'
require 'model/user'

class App < Sinatra::Base
  get '/admin/?' do
    books = Book.all
    users = User.all

    erb :index, locals: {books: books, users: users}
  end

  post '/admin/book' do
    create_book_from_params(@params)
    redirect to '/admin'
  end

  post '/admin/user' do
    create_user_from_params(@params)
    redirect to '/admin'
  end

  get '/api/books' do
    content_type :json
    api_key = request.env['HTTP_IRONHACK_API_KEY']

    books = find_books_for_user_with_api_key(api_key)

    render_books_as_json(books)
  end

  get '/api/books/:id' do
    content_type :json
    api_key = request.env['HTTP_IRONHACK_API_KEY']
    book_id = @params[:id]

    book =  find_book_with_id_owned_by_user_with_api_key(book_id, api_key)

    render_book_as_json(book)
  end

  post '/api/books' do
    content_type :json
    api_key = request.env['HTTP_IRONHACK_API_KEY']

    book = create_book_from_request_for_user_with_api_key(@request, api_key)

    render_book_as_json(book)
  end

  error Mongoid::Errors::DocumentNotFound do
    raise not_found
  end

  private
  def create_book_from_params(params)
    book = Book.new

    # Validate form data
    author = params['author']
    raise 'Invalid Author' if author.length < 3 || author.length > 30
    book.author = author

    title = params['title']
    raise 'Invalid Title' if title.length < 3 || author.length > 30
    book.title = title

    year = Integer(params['year'])
    raise 'Invalid publish date' if year > DateTime.now.year
    book.published_at = DateTime.new(year)

    # Set owner
    owner = User.find(params['owner'])
    book.owner = owner

    # Save book
    book.save
  end

  def create_user_from_params(params)
    user = User.new
    user.name = params['name']
    user.last_name = params['last_name']

    generate_api_key_for_user(user)

    user.save
  end

  def create_book_from_request_for_user_with_api_key(request, api_key)
    owner = User.find_by(api_key: api_key)

    # Create book from request
    requestData = JSON.parse(request.body.read)
    book = Book.new
    book.title = requestData['title']
    book.author = requestData['author']
    book.published_at = DateTime.iso8601(requestData['publish_date'])
    book.owner = owner

    # Save book
    book.save

    book
  end

  def generate_api_key_for_user(user)
    apiKey = "A-#{([nil]*8).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join}"
    while User.where(api_key: apiKey).exists?
      apiKey = "A-#{([nil]*8).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join}"
    end
    user.api_key = apiKey
  end

  ## Find
  def find_books_for_user_with_api_key(apiKey)
    # Get books for user with apiKey
    user = User.find_by(api_key: apiKey)
    user.books
  end

  def find_book_with_id_owned_by_user_with_api_key(book_id, api_key)
    owner = User.find_by(api_key: api_key)
    owner.books.find(book_id)
  end

  ## Render
  def render_books_as_json(books)
    result = []
    books.each do |book|
      result << book_to_hash(book)
    end
    result.to_json
  end

  def render_book_as_json(book)
    book_to_hash(book).to_json
  end

  def book_to_hash(book)
    {id: book._id, title: book.title, author: book.author, publish_date: book.published_at.iso8601}
  end
end