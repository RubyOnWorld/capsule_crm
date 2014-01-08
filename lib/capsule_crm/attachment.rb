module CapsuleCRM
  class Attachment
    include Virtus

    include ActiveModel::Validations

    attribute :id,            Integer
    attribute :filename,      String
    attribute :content_type,  String

    validates :id, numericality: { allow_blank: true }
  end
end
