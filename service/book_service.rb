class BookService
  def initialize(book_repository, user_repository)
    @book_repository = book_repository
    @user_repository = user_repository
  end

  def create_from_params(params)
    owner_id = params['owner']
    owner = @user_repository.find_by_ids(owner_id)
    create_from_params_and_owner(params, owner)
  end

  def create_from_params_for_user_with_api_key(params, api_key)
    owner = @user_repository.find_by_criteria(api_key: api_key)
    create_from_params_and_owner(params, owner)
  end

  def find_by_id_owned_by_user_with_api_key(id, api_key)
    owner = @user_repository.find_by_criteria(api_key: api_key)
    owner.books.find(id)
  end

  def find_owned_by_user_with_api_key(api_key)
    owner = @user_repository.find_by_criteria(api_key: api_key)
    owner.books
  end

  private
  def create_from_params_and_owner(params, owner)
    book = Book.from_params(params)
    book.owner = owner
    @book_repository.save(book)
    book
  end
end