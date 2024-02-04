class Grade
  VALUES = { 11 => '11 клас', 10 => '10 клас', 9 => '9 клас', 8 => '8 клас', 7 => '7 клас і нижче' }.freeze

  include ActiveModel::Model

  attr_accessor :id, :name

  def [] key
    public_send key
  end

  class << self
    def all
      VALUES.map { |id, name| new id:, name: }
    end

    def find id
      new id:, name: VALUES[id] if VALUES.key? id
    end

    def find_each(...) = all.each(...)
  end
end
