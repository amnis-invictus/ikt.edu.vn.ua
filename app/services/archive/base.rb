module Archive
  class Base
    def initialize contest
      @contest = contest
      @path = "/tmp/#{contest.id}_#{self.class::FILENAME_SUFFIX}.zip"
    end

    def build
      write_archive
      File.open(@path).tap do |io|
        @contest.update! self.class::ATTACHMENT_NAME => { io:, filename: File.basename(@path) }
      end
    end

    private

    def write_archive
      FileUtils.remove @path, force: true
      Zip::File.open(@path, create: true) do |zip|
        @contest.users.includes(solutions: [:task, file_attachment: :blob]).find_each do |user|
          secret = fetch_secret user
          fetch_solutions(user).each { write_solution zip, secret, _1 unless _1.nil? }
        end
      end
    end

    def write_solution zip, dir, solution
      task_prefix = "#{solution.upload_number}_" if solution.task.upload_limit > 1
      zip_path = "#{dir}/#{task_prefix}#{solution.file.filename}"
      # TODO: Consider another approach, works only with ActiveStorage::Service::DiskService v6.1.4.1
      source_path = ActiveStorage::Blob.service.path_for solution.file.key
      zip.add zip_path, source_path
    end
  end
end
