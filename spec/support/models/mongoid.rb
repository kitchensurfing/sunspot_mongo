class MongoidTestDocument
  include Mongoid::Document
  include Sunspot::Mongo

  has_one :mongoid_test_document_two

  field :title

  searchable do
    text :title
  end
end

class MongoidTestDocumentTwo
  include Mongoid::Document
  include Sunspot::Mongo

  belongs_to :mongoid_test_document

  field :title

  searchable do
    text :title
  end
end
