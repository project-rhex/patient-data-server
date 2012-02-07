require 'ostruct'

# A registry where hData extensionIds can be mapped to url paths and vice versa
#
# Note - This class gets configured in config/initializers/hdata_sections.rb
#
class SectionRegistry
  include Singleton
  
  def initialize
    @extensions = []
  end
  
  # Adds an hData section to the registry
  # @param [String] path the location in the web application where this section is registered.
  #                      For example: 'results'
  # @param [String] extension_id the URI that identifies the type of the section
  # @param [String] name a human readable name for the section
  # @yield [Hash, Hash] If a block is provided, hashes are given that can be used to add importers
  #                     and exporters. The Hash key should be a String representing a Mime Type. 
  #                     The value should be the importer/exporter.
  def add_section(path, extension_id, name)
    importers = {}
    exporters = {}
    yield importers, exporters if block_given?
    @extensions << OpenStruct.new(path: path, extension_id: extension_id, name: name,
                                  importers: importers, exporters: exporters)
  end
  
  # Finds an extension based on the path passed in
  # @param [String] path the path of the extension you are looking for
  # @return an object that has the name, path, extension, importers and exporters for the path
  def extension_from_path(path)
    @extensions.find {|e| e.path == path}
  end
end