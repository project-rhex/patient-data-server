namespace :hdata do
  
  desc "Loads local C32 files from test/fixtures/*Smith*.xml"
  task :load_c32_files => :environment do
    def next_med_rec_num
      records = Record.all

      highest_med_rec_num = 0
      records.each do |rec|
        if rec.medical_record_number.to_i > highest_med_rec_num 
          highest_med_rec_num =  rec.medical_record_number.to_i
        end
      end

      highest_med_rec_num += 1
    end

    if ENV['MONGOHQ_URL']
      # uri = URI.parse(ENV['MONGOHQ_URL'])
      @conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
      @db   = @conn['hdata_server_production']
      @coll = @db['records']
    else
      @db   = Moped::Session.new(["127.0.0.1:27017"]).use('hdata_server_development')
      @coll = @db['records']
    end

    ## read XML files and load into DB
    files = Dir.glob("#{Rails.root}/test/fixtures/*Smith*.xml")

    # files = Dir.glob(File.dirname(__FILE__) + "/../test/fixtures/*Smith*.xml")
    files.each do |file|
      doc = Nokogiri::XML(File.read(file))

      doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
      pi = HealthDataStandards::Import::C32::PatientImporter.instance

      patient = pi.parse_c32(doc)
     
      #Record.create!(patient)p
      patient.medical_record_number = next_med_rec_num
 
      patient.save
    end
    
  end
  

##############
##############
  desc "Loads local C32 providers from test/fixtures/*Smith*.xml"
  task :load_c32_providers => :environment do

    if ENV['MONGOHQ_URL']
      # uri = URI.parse(ENV['MONGOHQ_URL'])
      @conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
      @db   = @conn['hdata_server_production']
      @coll = @db['records']
    else
      @db   = Moped::Session.new(["127.0.0.1:27017"]).use('hdata_server_development')
      @coll = @db['records']
    end

    ## read XML files and load into DB
    files = Dir.glob("#{Rails.root}/test/fixtures/*Smith*.xml")
    files.each do |file|

       nist_doc = Nokogiri::XML(File.new(file))
       nist_doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
       importer = HealthDataStandards::Import::C32::ProviderImporter.instance

       providers = importer.extract_providers(nist_doc)

       providers.each do |provider|
         p = Provider.new provider
         p.save!
       end
    end
    
  end


end