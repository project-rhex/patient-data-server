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
      @conn = Mongo::Connection.new
      #@db   = @conn['hds-atest']
      @db   = @conn['hdata_server_development']
      @coll = @db['records']
    end

    #puts "There are #{@coll.count} records. Here they are:"
    #@coll.find.each { |doc| puts doc.inspect }


    ## read XML files and load into DB
    files = Dir.glob("#{Rails.root}/test/fixtures/*Smith*.xml")
    puts "Files #{files}"
    # files = Dir.glob(File.dirname(__FILE__) + "/../test/fixtures/*Smith*.xml")
    files.each do |file|
      doc = Nokogiri::XML(File.read(file))

      doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
      pi = HealthDataStandards::Import::C32::PatientImporter.instance

      patient = pi.parse_c32(doc)
      puts "****** patient"
      puts patient.inspect
      puts patient.medical_record_number
=begin
puts "****** allergies"
puts patient.allergies.inspect
puts "****** care goals"
puts patient.care_goals.inspect
puts "****** conditions"
puts patient.conditions.inspect
puts "****** encounters"
puts patient.encounters.inspect
puts "****** immunizations"
puts patient.immunizations.inspect
puts "****** medical equip"
puts patient.medical_equipment.inspect
puts "****** medications"
puts patient.medications.inspect
puts "****** procedures"
puts patient.procedures.inspect
puts "****** results"
puts patient.results.inspect
puts "****** social history"
puts patient.social_history.inspect
puts "****** vital signs"
puts patient.vital_signs.inspect
=end

      ##@db.@coll.insert(patient)
      # Mongoid.load!("#{File.dirname(__FILE__)}/../config/mongoid.yml")
      # Mongoid.configure do |config|
      #   if ENV['MONGOHQ_URL']
      #     config.master = Mongo::Connection.from_uri(ENV['MONGOHQ_URL']).db("hdata_server_production")
      #   else
      #     config.master = Mongo::Connection.new.db("hdata_server_development")
      #   end
      # end

      #Record.create!(patient)p
      patient.medical_record_number = next_med_rec_num
      puts "Saving record: #{patient.medical_record_number}"
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
      @conn = Mongo::Connection.new
      #@db   = @conn['hds-atest']
      @db   = @conn['hdata_server_development']
      @coll = @db['records']
    end

    ## read XML files and load into DB
    files = Dir.glob("#{Rails.root}/test/fixtures/*Smith*.xml")
    puts "Files #{files}"
    # files = Dir.glob(File.dirname(__FILE__) + "/../test/fixtures/*Smith*.xml")
    files.each do |file|
       nist_doc = Nokogiri::XML(File.new(file))
       nist_doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
       importer = HealthDataStandards::Import::C32::ProviderImporter.instance

       providers = importer.extract_providers(nist_doc)

       puts "****** providers"
       puts providers.inspect

       providers.each do |provider|
         p = Provider.new provider
         puts "ERR" if p.save! == false
         puts "Saved a provider! #{p.title} #{p.family_name} of #{p.organization}"
       end
    end
    
  end


end