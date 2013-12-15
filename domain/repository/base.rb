require 'mongoid'
require 'domain/repository/Exception/not_found'
module Base
  def find_all
    @model_class.all
  end

  def save!(model)
    model.save!
  end

  def save(model)
    model.save
  end

  def delete(model)
    model.delete
  end

  def find_by_criteria(criteria)
    begin
      @model_class.find_by(criteria)
    rescue Mongoid::Errors::DocumentNotFound
      raise NotFound
    end
  end

  def find_by_ids(ids)
    begin
      @model_class.find(ids)
    rescue Mongoid::Errors::DocumentNotFound
      raise NotFound
    end
  end

  def exists_with_criteria?(criteria)
    @model_class.where(criteria).exists?
  end
end