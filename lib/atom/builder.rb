# Subclass just to add entries iteration to Nokogiri
module Atom
  class Builder < Nokogiri::XML::Builder
    # Create entries from iterable collection
    #
    # @param collection an iterable collection suitable for .each block
    #
    # This will pass the collection entry to the block. The xml instance
    # is expection to be available via the lexical scope
    def entries(collection)
      collection.each do |x|
        entry do
          yield x
        end
      end
    end
  end

  # You must create a Document class in the module if you create a builder
  # class because the Nokogiri code references it to create the document
  # root.
  class Document < Nokogiri::XML::Document

  end
end