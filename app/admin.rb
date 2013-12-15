require 'dependencies/dependency_manager'

class Admin < Sinatra::Base
  include DependencyManager

  def initialize(app = nil)
    super
    load_dependencies
  end

  get '/?' do
    books = @book_repository.find_all
    users = @user_repository.find_all

    erb :index, locals: {books: books, users: users}
  end

  post '/book/?' do
    @book_service.create_from_params(@params)
    redirect to '/'
  end

  post '/user?' do
    @user_service.create_from_params_with_new_api_key(@params)
    redirect to '/'
  end
end