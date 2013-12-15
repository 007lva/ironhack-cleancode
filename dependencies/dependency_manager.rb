require 'domain/repository/book_repository'
require 'domain/repository/user_repository'
require 'service/book_service'
require 'service/user_service'

module DependencyManager
  def load_dependencies
    @book_repository = BookRepository.new
    @user_repository = UserRepository.new

    @book_service = BookService.new(@book_repository, @user_repository)
    @user_service = UserService.new(@user_repository)
  end
end