require 'domain/repository/base'
require 'domain/model/user'

class UserRepository
  include Base

  def initialize
    @model_class = User
  end
end