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
    book = Book.new

    # Validate form data
    author = @params['author']
    raise 'Invalid Author' if author.length < 3 || author.length > 30
    book.author = author

    title = @params['title']
    raise 'Invalid Title' if title.length < 3 || author.length > 30
    book.title = title

    year = Integer(@params['year'])
    raise 'Invalid publish date' if year > DateTime.now.year
    book.published_at = DateTime.new(year)

    # Set owner
    owner = User.find(@params['owner'])
    book.owner = owner

    # Save book
    book.save

    redirect to '/admin'
  end

  post '/admin/user' do
    user = User.new
    user.name = @params['name']
    user.last_name = @params['last_name']

    # Generate API Key
    apiKey = "A-#{([nil]*8).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join}"
    while User.where(api_key: apiKey).exists?
      apiKey = "A-#{([nil]*8).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join}"
    end
    user.api_key = apiKey

    # Save user
    user.save

    redirect to '/admin'
  end

  get '/api/books' do
    content_type :json
    apiKey = request.env['HTTP_IRONHACK_API_KEY']

    # Get books for user with apiKey
    user = User.find_by(api_key: apiKey)
    books = user.books
    result = []

    # Render as json
    books.each do |book|
      result << {id: book._id, title: book.title, author: book.author, publish_date: book.published_at.iso8601}
    end

    result.to_json
  end

  get '/api/books/:id' do
    content_type :json
    apiKey = request.env['HTTP_IRONHACK_API_KEY']

    # Get book for user with apiKey
    owner = User.find_by(api_key: apiKey)
    book = owner.books.find(@params[:id])

    # Render as json
    {id: book._id, title: book.title, author: book.author, publish_date: book.published_at.iso8601}.to_json
  end

  post '/api/books' do
    content_type :json
    apiKey = request.env['HTTP_IRONHACK_API_KEY']
    owner = User.find_by(api_key: apiKey)

    # Create book from request
    requestData = JSON.parse(@request.body.read)
    book = Book.new
    book.title = requestData['title']
    book.author = requestData['author']
    book.published_at = DateTime.iso8601(requestData['publish_date'])
    book.owner = owner

    # Save book
    book.save

    # Render as json
    {id: book._id, title: book.title, author: book.author, publish_date: book.published_at.iso8601}.to_json
  end

  error Mongoid::Errors::DocumentNotFound do
    raise not_found
  end
end