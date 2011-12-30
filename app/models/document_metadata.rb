class DocumentMetadata
  include Mongoid::Document
  
  field :author, type: String
  field :organization, type: String
  field :confidentiality, type: String
  field :linked_documents, type: Array

  embedded_in :entry
end