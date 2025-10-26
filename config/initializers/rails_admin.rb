Rails.root.glob('lib/rails_admin/**/*.rb').each { require _1 }

RailsAdmin::Config::Fields::Types.register :citext, RailsAdmin::Config::Fields::Types::Citext
RailsAdmin::Config::Fields::Types.register :pg_string_array, RailsAdmin::Config::Fields::Types::PgStringArray
RailsAdmin::Config::Fields::Types.register :pg_inet_array, RailsAdmin::Config::Fields::Types::PgInetArray
RailsAdmin::Config::Fields::Types.register :pg_int_array, RailsAdmin::Config::Fields::Types::PgIntArray

RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::ArchiveAll
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::ArchiveJudgeAll
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::ArchiveJudgeLast
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::ChecksumDuplicates
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::IpsMismatch
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::DeviceIdsMismatch
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::MetadataMismatch
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::SpreadsheetJudge
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::SpreadsheetPublic
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::AssignServices
RailsAdmin::Config::Actions.register RailsAdmin::Config::Actions::RemoveServices

RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.asset_source = :sprockets

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete

    archive_all
    archive_judge_all
    archive_judge_last
    checksum_duplicates
    ips_mismatch
    device_ids_mismatch
    metadata_mismatch
    spreadsheet_judge
    spreadsheet_public
    assign_services
    remove_services

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.authorize_with do
    authenticate_or_request_with_http_basic 'Login required' do |username, password|
      expected_user = Rails.application.credentials.dig :admin, :user
      expected_pass = Rails.application.credentials.dig :admin, :password

      ActiveSupport::SecurityUtils.secure_compare(username, expected_user) &&
        ActiveSupport::SecurityUtils.secure_compare(password, expected_pass)
    end
  end

  config.parent_controller = 'AdminController'

  config.model 'Task' do |_config|
    configure :file_names, :pg_string_array
    configure :judges, :pg_string_array
    configure(:solutions) { hide }
    configure(:results) { hide }
    configure(:criterions) { hide }
    configure(:comments) { hide }
  end

  config.model 'User' do |_config|
    configure :registration_ips, :pg_inet_array
    configure(:solutions) { hide }
    configure(:results) { hide }
    configure(:comments) { hide }
    configure(:criterion_user_results) { hide }
  end

  config.model 'Solution' do |_config|
    configure :ips, :pg_inet_array
  end

  config.model 'Contest' do |_config|
    configure :cities, :pg_string_array
    configure :institutions, :pg_string_array
    configure :contest_sites, :pg_string_array
    configure :sleep_services, :pg_int_array
    configure(:tasks) { hide }
    configure(:users) { hide }
    configure(:solutions) { hide }
  end

  config.model 'Criterion' do |_config|
    configure(:criterion_user_results) { hide }
  end
end
