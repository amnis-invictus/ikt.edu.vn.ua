module Spreadsheet
  class ConfigPublic
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :header, :string
    attribute :result_table, :boolean
    attribute :main_judge, :boolean
    attribute :judge_list, :boolean
    attribute :orgcom_head, :boolean
    attribute :orgcom_secretary, :boolean
    attribute :appeal_head, :boolean
  end
end
