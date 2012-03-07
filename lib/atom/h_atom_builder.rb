# Subclass just to add entries iteration to Nokogiri
class HAtomBuilder < Nokogiri::XML::Builder
  # Create entries from iterable collection
  #
  # @param collection an iterable collection suitable for .each block
  #
  # This will pass the collection entry to the block. The xml instance
  # is expection to be available via the lexical scope
  def entries(collection)
    collection.each do |x|
      entry {
        yield x
      }
    end
  end
end