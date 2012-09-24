xml.root xmlns: "http://projecthdata.org/hdata/schemas/2009/06/core", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance" do
  xml.id @record.medical_record_number
  xml.version @record.version
  xml.created do
    if @record.created_at
      @record.created_at.to_s(:xsd)
    else
      nil
    end
  end
  xml.lastModified do
    if @record.updated_at
      @record.updated_at.to_s(:xsd)
    else
      nil
    end
  end
  
  extensions = SectionRegistry.instance.extensions
  ids = extensions.collect{|x| x.extension_id }.uniq
  ex_id_map = {}
  _id = 1
  xml.extensions do
    xml.extension("http://projecthdata.org/extension/c32", extensionId: 1)
    ids.each do |ex_id|
      unless ex_id_map[ex_id] 
        _id = _id + 1
        ex_id_map[ex_id] = _id
        xml.extension(ex_id, extensionId: _id)
      end
   end
  end
  xml.sections do
    xml.section(path: "c32", name: "C32", extensionId: 1)
    extensions.each do |extension|
      xml.section(path: "#{extension.path}", name: extension.name.titleize, extensionId: ex_id_map[extension.extension_id])
    end
  end
end