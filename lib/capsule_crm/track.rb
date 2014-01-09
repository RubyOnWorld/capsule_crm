module CapsuleCRM
  class Track
    include Virtus

    extend  ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    include CapsuleCRM::Associations
    include CapsuleCRM::Attributes
    include CapsuleCRM::Collection

    attribute :id,            Integer
    attribute :description,   String
    attribute :capture_rule,  String

    has_many :opportunities, class_name: 'CapsuleCRM::Opportunity'
    has_many :cases, class_name: 'CapsuleCRM::Case'

    validates :id, numericality: { allow_blank: true }

    def self.all
      init_collection(
        CapsuleCRM::Connection.get('/api/tracks')['tracks']['track']
      )
    end
  end
end