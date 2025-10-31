require 'English'
require 'rails_helper'

# rubocop:disable RSpec/SpecFilePathFormat, RSpec/MultipleMemoizedHelpers
RSpec.describe Archive::Base, type: :integration do
  let(:contest) { create :contest, :active }
  let(:first_task) { Task.create! contest: contest, display_name: 'Task 1', file_names: ['solution1.txt'], upload_limit: 2 }
  let(:second_task) { Task.create! contest: contest, display_name: 'Task 2', file_names: ['solution2.txt'], upload_limit: 1 }
  let(:first_user) { create :user, contest: contest, secret: 'user1secret' }
  let(:second_user) { create :user, contest: contest, secret: 'user2secret' }

  before do
    # Create tasks
    first_task
    second_task

    # Create solutions with actual file attachments for first_user
    solution1 = Solution.create! user: first_user,
      task: first_task,
      upload_number: 1,
      ips: ['127.0.0.1'],
      device_id: 'device1'
    solution1.file.attach io: StringIO.new('User 1 solution for task 1'),
      filename: 'solution1.txt',
      content_type: 'text/plain'

    solution2 = Solution.create! user: first_user,
      task: second_task,
      upload_number: 1,
      ips: ['127.0.0.1'],
      device_id: 'device1'
    solution2.file.attach io: StringIO.new('User 1 solution for task 2'),
      filename: 'solution2.txt',
      content_type: 'text/plain'

    # Create solutions with actual file attachments for second_user
    solution3 = Solution.create! user: second_user,
      task: first_task,
      upload_number: 1,
      ips: ['127.0.0.1'],
      device_id: 'device2'
    solution3.file.attach io: StringIO.new('User 2 solution for task 1'),
      filename: 'solution1.txt',
      content_type: 'text/plain'
  end

  describe 'Archive::UserAll' do
    let(:archive_service) { Archive::UserAll.new contest }
    let :zip_entries do
      archive_service.build
      zip_data = contest.all_archive.download
      entries = []
      Zip::File.open_buffer StringIO.new(zip_data) do |zip_file|
        entries = zip_file.entries
      end
      entries
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'creates a zip archive with all user solutions using rubyzip 3.x API' do
      expect { archive_service.build }.to_not raise_error
      expect(contest.all_archive).to be_attached
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/ExampleLength
    it 'includes all user solutions in the archive' do
      entry_names = zip_entries.map(&:name).sort
      aggregate_failures do
        expect(entry_names).to include('user1secret/solution1.txt')
        expect(entry_names).to include('user1secret/solution2.txt')
        expect(entry_names).to include('user2secret/solution1.txt')
      end
    end

    it 'stores correct file contents in the archive' do
      archive_service.build
      zip_data = contest.all_archive.download
      Zip::File.open_buffer StringIO.new(zip_data) do |zip_file|
        user1_solution1 = zip_file.find_entry 'user1secret/solution1.txt'
        expect(user1_solution1.get_input_stream.read).to eq('User 1 solution for task 1')
      end
    end
    # rubocop:enable RSpec/ExampleLength

    it 'creates a valid zip file that can be extracted' do
      archive_service.build
      zip_data = contest.all_archive.download

      Zip::File.open_buffer StringIO.new(zip_data) do |zip_file|
        expect(zip_file.entries.count).to eq(3)
      end
    end
  end

  describe 'Archive::JudgeAll' do
    # rubocop:disable RSpec/MultipleExpectations
    it 'creates a zip archive with all solutions organized by judge_secret using rubyzip 3.x API' do
      # Set judge_secret for users
      first_user.update! judge_secret: 'judge1'
      second_user.update! judge_secret: 'judge2'

      archive_service = Archive::JudgeAll.new contest
      expect { archive_service.build }.to_not raise_error
      expect(contest.all_judge_archive).to be_attached
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/ExampleLength
    it 'organizes solutions by judge_secret in the archive' do
      first_user.update! judge_secret: 'judge1'
      second_user.update! judge_secret: 'judge2'

      archive_service = Archive::JudgeAll.new contest
      archive_service.build
      zip_data = contest.all_judge_archive.download

      Zip::File.open_buffer StringIO.new(zip_data) do |zip_file|
        entries = zip_file.entries.map(&:name).sort
        aggregate_failures do
          expect(entries).to include('judge1/solution1.txt')
          expect(entries).to include('judge1/solution2.txt')
          expect(entries).to include('judge2/solution1.txt')
        end
      end
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'Multiple uploads per task' do
    # rubocop:disable RSpec/ExampleLength
    it 'handles multiple uploads per task with upload number prefix' do
      # Create a second upload for first_user's first_task
      solution4 = Solution.create! user: first_user,
        task: first_task,
        upload_number: 2,
        ips: ['127.0.0.1'],
        device_id: 'device1'
      solution4.file.attach io: StringIO.new('User 1 second solution for task 1'),
        filename: 'solution1.txt',
        content_type: 'text/plain'

      archive_service = Archive::UserAll.new contest
      archive_service.build
      zip_data = contest.all_archive.download

      Zip::File.open_buffer StringIO.new(zip_data) do |zip_file|
        entries = zip_file.entries.map(&:name).sort
        aggregate_failures do
          expect(entries).to include('user1secret/1_solution1.txt')
          expect(entries).to include('user1secret/2_solution1.txt')
        end
      end
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'Rubyzip 3.x API compatibility' do
    # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
    it 'uses the create: true parameter instead of Zip::File::CREATE constant' do
      archive_service = Archive::UserAll.new contest
      expect { archive_service.build }.to_not raise_error

      temp_path = "/tmp/#{contest.id}_users.zip"
      expect(File.exist?(temp_path)).to be true
    end

    it 'creates zip files compatible with rubyzip 3.x API' do
      archive_service = Archive::UserAll.new contest
      archive_service.build

      temp_path = "/tmp/#{contest.id}_users.zip"
      Zip::File.open temp_path do |zip_file|
        expect(zip_file).to be_a Zip::File
      end
    end

    it 'creates zip files that are compatible with standard zip tools' do
      archive_service = Archive::UserAll.new contest
      archive_service.build

      temp_path = "/tmp/#{contest.id}_users.zip"
      `unzip -l "#{temp_path}" 2>&1`
      expect($CHILD_STATUS.success?).to be true
    end

    it 'includes expected files when verified with zip tools' do
      archive_service = Archive::UserAll.new contest
      archive_service.build

      temp_path = "/tmp/#{contest.id}_users.zip"
      output = `unzip -l "#{temp_path}" 2>&1`
      aggregate_failures do
        expect(output).to include('solution1.txt')
        expect(output).to include('solution2.txt')
      end
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
  end
end
# rubocop:enable RSpec/SpecFilePathFormat, RSpec/MultipleMemoizedHelpers
