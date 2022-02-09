module FormHelpers
  def fill_inputs prefix, params
    within 'form' do
      params.each do |name, value|
        fill_in "#{prefix}_#{name}", with: value if value.present?
      end
    end
  end

  def fill_selects prefix, params
    within 'form' do
      params.each do |name, value|
        select value, from: "#{prefix}_#{name}" if value.present?
      end
    end
  end
end
