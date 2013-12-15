class UserService
  def initialize(user_repository)
    @user_repository = user_repository
  end

  def create_from_params_with_new_api_key(params)
    user = User.from_params(params)
    user.api_key = generate_api_key
    user.save
    user
  end

  private
  def generate_api_key
    begin
      api_key = User.generate_api_key
    end while @user_repository.exists_with_criteria?(api_key: api_key)

    api_key
  end
end