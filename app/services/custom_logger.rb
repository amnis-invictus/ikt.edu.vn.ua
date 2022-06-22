class CustomLogger
  class << self
    def write contest_id:, device_id:, action:, status:, values:, exception: nil
      values.map! { |name, val| "#{name}=#{val.to_json}" }
      values << "exception=#{exception}" if exception
      logger(contest_id).info("[#{device_id}] #{action} #{status}: #{values.join '; '}")
    end

    private

    def logger contest_id
      @logger ||= {}
      @logger[contest_id] ||= Logger.new Rails.root.join 'log', "custom-#{contest_id}.log"
    end
  end
end
