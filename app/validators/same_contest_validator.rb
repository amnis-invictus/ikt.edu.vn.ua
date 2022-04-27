class SameContestValidator < ActiveModel::Validator
  def validate record
    values = options[:for].filter_map { record.public_send(_1)&.contest }

    record.errors.add :base, options[:message] unless values.each_cons(2).all? { |ci, cj| ci == cj }
  end
end
