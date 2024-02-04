class JSONType < ActiveModel::Type::Value
  def type = :json

  private

  def cast_value(value) = value.is_a?(String) ? JSON.parse(value) : value
end
