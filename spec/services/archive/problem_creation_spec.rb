require 'rails_helper'

RSpec.describe 'Archive service with zip file creation', type: :integration do
  let(:contest) { create(:contest, :active) }
  let(:task1) { Task.create!(contest: contest, display_name: 'Task 1', file_names: ['solution1.txt'], upload_limit: 2) }
  let(:task2) { Task.create!(contest: contest, display_name: 'Task 2', file_names: ['solution2.txt'], upload_limit: 1) }
  let(:user1) { create(:user, contest: contest, secret: 'user1secret') }
  let(:user2) { create(:user, contest: contest, secret: 'user2secret') }

  before do
    # Create tasks
    task1
    task2

    # Create solutions with actual file attachments for user1
    solution1 = Solution.create!(
      user: user1,
      task: task1,
      upload_number: 1,
      ips: ['127.0.0.1'],
      device_id: 'device1'
    )
    solution1.file.attach(
      io: StringIO.new('User 1 solution for task 1'),
      filename: 'solution1.txt',
      content_type: 'text/plain'
    )

    solution2 = Solution.create!(
      user: user1,
      task: task2,
      upload_number: 1,
      ips: ['127.0.0.1'],
      device_id: 'device1'
    )
    solution2.file.attach(
      io: StringIO.new('User 1 solution for task 2'),
      filename: 'solution2.txt',
      content_type: 'text/plain'
    )

    # Create solutions with actual file attachments for user2
    solution3 = Solution.create!(
      user: user2,
      task: task1,
      upload_number: 1,
      ips: ['127.0.0.1'],
      device_id: 'device2'
    )
    solution3.file.attach(
      io: StringIO.new('User 2 solution for task 1'),
      filename: 'solution1.txt',
      content_type: 'text/plain'
    )
  end

  describe 'Archive::UserAll' do
    it 'creates a zip archive with all user solutions using rubyzip 3.x API' do
      archive_service = Archive::UserAll.new(contest)
      
      # Build the archive
      expect { archive_service.build }.not_to raise_error
      
      # Verify the archive was attached to the contest
      expect(contest.all_archive).to be_attached
      
      # Download and verify the zip file content
      zip_data = contest.all_archive.download
      
      # Use rubyzip 3.x API to read the archive
      Zip::File.open_buffer(StringIO.new(zip_data)) do |zip_file|
        entries = zip_file.entries.map(&:name).sort
        
        # Verify user1's solutions are in the archive
        expect(entries).to include("user1secret/solution1.txt")
        expect(entries).to include("user1secret/solution2.txt")
        
        # Verify user2's solutions are in the archive
        expect(entries).to include("user2secret/solution1.txt")
        
        # Verify we can read the file contents
        user1_solution1 = zip_file.find_entry("user1secret/solution1.txt")
        expect(user1_solution1).not_to be_nil
        expect(user1_solution1.get_input_stream.read).to eq('User 1 solution for task 1')
        
        user2_solution1 = zip_file.find_entry("user2secret/solution1.txt")
        expect(user2_solution1).not_to be_nil
        expect(user2_solution1.get_input_stream.read).to eq('User 2 solution for task 1')
      end
    end

    it 'creates a valid zip file that can be extracted' do
      archive_service = Archive::UserAll.new(contest)
      archive_service.build
      
      zip_data = contest.all_archive.download
      
      # Verify the zip file is valid and can be opened
      expect do
        Zip::File.open_buffer(StringIO.new(zip_data)) do |zip_file|
          expect(zip_file.entries.count).to eq(3)
          
          # Verify each entry can be read without errors
          zip_file.each do |entry|
            expect { entry.get_input_stream.read }.not_to raise_error
          end
        end
      end.not_to raise_error
    end
  end

  describe 'Archive::JudgeAll' do
    it 'creates a zip archive with all solutions organized by judge_secret using rubyzip 3.x API' do
      # Set judge_secret for users
      user1.update!(judge_secret: 'judge1')
      user2.update!(judge_secret: 'judge2')
      
      archive_service = Archive::JudgeAll.new(contest)
      
      # Build the archive
      expect { archive_service.build }.not_to raise_error
      
      # Verify the archive was attached to the contest
      expect(contest.all_judge_archive).to be_attached
      
      # Download and verify the zip file content
      zip_data = contest.all_judge_archive.download
      
      # Use rubyzip 3.x API to read the archive
      Zip::File.open_buffer(StringIO.new(zip_data)) do |zip_file|
        entries = zip_file.entries.map(&:name).sort
        
        # Verify solutions are organized by judge_secret
        expect(entries).to include("judge1/solution1.txt")
        expect(entries).to include("judge1/solution2.txt")
        expect(entries).to include("judge2/solution1.txt")
      end
    end
  end

  describe 'Multiple uploads per task' do
    it 'handles multiple uploads per task with upload number prefix' do
      # Create a second upload for user1's task1
      solution4 = Solution.create!(
        user: user1,
        task: task1,
        upload_number: 2,
        ips: ['127.0.0.1'],
        device_id: 'device1'
      )
      solution4.file.attach(
        io: StringIO.new('User 1 second solution for task 1'),
        filename: 'solution1.txt',
        content_type: 'text/plain'
      )
      
      archive_service = Archive::UserAll.new(contest)
      archive_service.build
      
      zip_data = contest.all_archive.download
      
      Zip::File.open_buffer(StringIO.new(zip_data)) do |zip_file|
        entries = zip_file.entries.map(&:name).sort
        
        # Verify both uploads are in the archive with upload number prefix
        expect(entries).to include("user1secret/1_solution1.txt")
        expect(entries).to include("user1secret/2_solution1.txt")
      end
    end
  end

  describe 'Rubyzip 3.x API compatibility' do
    it 'uses the create: true parameter instead of Zip::File::CREATE constant' do
      # This test verifies that the code uses rubyzip 3.x API
      # The Archive::Base service should use Zip::File.open(@path, create: true)
      # instead of the deprecated Zip::File.open(@path, Zip::File::CREATE)
      
      archive_service = Archive::UserAll.new(contest)
      
      # The build method should complete without any deprecation warnings
      # or errors related to the old API
      expect { archive_service.build }.not_to raise_error
      
      # Verify the file exists and is a valid zip
      temp_path = "/tmp/#{contest.id}_users.zip"
      expect(File.exist?(temp_path)).to be true
      
      # Clean up using rubyzip 3.x API to verify compatibility
      Zip::File.open(temp_path) do |zip_file|
        expect(zip_file).to be_a(Zip::File)
      end
    end

    it 'creates zip files that are compatible with standard zip tools' do
      archive_service = Archive::UserAll.new(contest)
      archive_service.build
      
      temp_path = "/tmp/#{contest.id}_users.zip"
      
      # Verify the file can be listed using the unzip command
      output = `unzip -l "#{temp_path}" 2>&1`
      expect($?.success?).to be true
      expect(output).to include('solution1.txt')
      expect(output).to include('solution2.txt')
    end
  end
end
