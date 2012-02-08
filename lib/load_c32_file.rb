require 'rubygems'
require 'bundler'
require 'mongo'
require 'nokogiri'
require 'health-data-standards'


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


@conn = Mongo::Connection.new
#@db   = @conn['hds-atest']
@db   = @conn['hdata_server_development']
@coll = @db['records']

#puts "There are #{@coll.count} records. Here they are:"
#@coll.find.each { |doc| puts doc.inspect }


## read XML files and load into DB
files = Dir.glob(File.dirname(__FILE__) + "/../test/fixtures/*.xml")
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
  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db("hdata_server_development")
  end
  
  #Record.create!(patient)p
  patient.medical_record_number = next_med_rec_num
  puts "Saving record: #{patient.medical_record_number}"
  patient.save
end


