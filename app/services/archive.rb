class Archive
  def initialize contest, user, last_only
    @contest = contest
    @last_only = last_only
    @user = user
  end

  def build
    archive_path = @user ? write_archive : write_judge_archive
    File.open(archive_path).tap do |io|
      attachment = { io:, filename: File.basename(archive_path) }
      if @last_only
        if @user
          @contest.last_archive = attachment
        else
          @contest.last_judge_archive = attachment
        end
      elsif @user
        @contest.all_archive = attachment
      else
        @contest.all_judge_archive = attachment
      end
      @contest.save!
    end
  end

  private

  def write_archive
    path = "/tmp/#{@contest.id}_users#{'_last' if @last_only}.zip"
    FileUtils.remove path, force: true
    Zip::File.open path, Zip::File::CREATE do |zip|
      fn = method(@last_only ? :write_last_solutions : :write_all_solutions)
      @contest.users.includes(solutions: [:task, file_attachment: :blob]).each { fn.call _1, zip }
    end
    path
  end

  def write_judge_archive
    path = "/tmp/#{@contest.id}_judge#{'_last' if @last_only}.zip"
    FileUtils.remove path, force: true
    Zip::File.open path, Zip::File::CREATE do |zip|
      fn = method(@last_only ? :write_judge_last_solutions : :write_judge_all_solutions)
      @contest.users.includes(solutions: [:task, file_attachment: :blob]).each { fn.call _1, zip }
    end
    path
  end

  def write_all_solutions user, zip
    user.solutions.each do |solution|
      write_solution zip, user.secret, solution
    end
  end

  def write_last_solutions user, zip
    @contest.tasks.each do |task|
      solution = user.solutions.where(task:).order(:id).last
      write_solution zip, user.secret, solution unless solution.nil?
    end
  end

  def write_judge_all_solutions user, zip
    user.solutions.each do |solution|
      write_solution zip, user.judge_secret, solution
    end
  end

  def write_judge_last_solutions user, zip
    @contest.tasks.each do |task|
      solution = user.solutions.where(task:).order(:id).last
      write_solution zip, user.judge_secret, solution unless solution.nil?
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
