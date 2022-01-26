module FormHelpers
  USER_SELECT_ATTRS = %i[city grade contest_site].freeze

  def fill_new_user_form params
    within 'form' do
      params.each do |name, value|
        next if value.blank?

        if USER_SELECT_ATTRS.include? name
          select value, from: "user_#{name}"
        else
          fill_in "user_#{name}", with: value
        end
      end
    end
  end
end
