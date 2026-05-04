module AthenaHealth
  class DocumentTypeCollection < BaseCollection
    attribute :documenttypes, Array[DocumentType]

    alias_method :document_types, :documenttypes
  end
end
