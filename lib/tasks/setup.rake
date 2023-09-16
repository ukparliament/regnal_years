require 'csv'

task :setup => [
  :import_monarchs,
  :import_reigns,
  :generate_regnal_years
]

task :import_monarchs => :environment do
  puts "importing monarchs"
  CSV.foreach( 'db/data/monarchs.csv' ) do |row|
    monarch = Monarch.new
    monarch.id = row[0]
    monarch.title = row[1]
    monarch.abbreviation = row[2]
    monarch.date_of_birth = row[4]
    monarch.date_of_death = row[5]
    monarch.wikidata_id = row[3]
    monarch.save
  end
end

task :import_reigns => :environment do
  puts "importing reigns"
  CSV.foreach( 'db/data/reigns.csv' ) do |row|
    reign = Reign.new
    reign.id = row[1]
    reign.start_on = row[2]
    reign.end_on = row[3]
    reign.monarch_id = row[0]
    reign.save
  end
end

task :generate_regnal_years => :environment do
  puts "generating regnal years"
  reigns = Reign.all.order( 'start_on' )
  reigns.each do |reign|
    
    # If the reign end on date is present ...
    if reign.end_on
      
      # ... we set the reign end on date to the end date of the reign.
      reign_end_on = reign.end_on
      
    # Otherwise, if the reign end on date is not present ...
    else
      
      # ... we assume the reign is ongoing and set the reign end on date to today's data.
      reign_end_on = Date.today
    end
    
    # We set the start date of the first regnal year to the start date of the reign.
    regnal_year_start_on = reign.start_on
    
    # If the start date of the reign plus a year minus a day is greater than the end date of the reign ...
    if reign.start_on + 1.year - 1.day > reign_end_on
      
      # ... we set the end date of the first regnal year to the end date of the reign.
      regnal_year_end_on = reign.end_on
      
    # Otherwise, if the start date of the reign plus a year minus a day is not greater than the end date of the reign ...
    else
      
      # ... we set the end date of the first regnal year to the start date of the reign plus a year minus a day.
      regnal_year_end_on = reign.start_on  + 1.year - 1.day
    end
    
    # We set the regnal year number.
    regnal_year_number = 1
    
    # We create the first regnal year.
    find_or_create_regnal_year( reign, regnal_year_number, regnal_year_start_on, regnal_year_end_on )
    
    # Whilst the end date of the regnal year is less than or equal to the end date of the reign ...
    while regnal_year_end_on != reign_end_on
      
      # We increment the regnal year number.
      regnal_year_number += 1
      
      # We increment the regnal year start date by one year.
      regnal_year_start_on += 1.year
      
      # If the end date of the next regnal year would be greater than the end date of the reign ...
      if regnal_year_end_on + 1.year > reign_end_on
        
        # ... we set the next regnal year end date to be the date of the end of the reign.
        regnal_year_end_on = reign_end_on
        
      # Otherwise, if the end date of the next regnal year is before than the end date of the reign ...
      else
      
        # ... we increment the next regnal year end date by one year
        regnal_year_end_on += 1.year
      end
      
      # We create the next regnal year.
      find_or_create_regnal_year( reign, regnal_year_number, regnal_year_start_on, regnal_year_end_on )
     end
  end
end

# ## A method to find or create a regnal year.
def find_or_create_regnal_year( reign, number, start_on, end_on )
  
  # We attempt to find a regnal year for this reign, with this number.
  regnal_year = RegnalYear.all.where( "reign_id = ?", reign.id ).where( "number = ?", number ).first
  
  # Unless we find the regnal year ...
  unless regnal_year
    
    # ... we create a new regnal year.
    regnal_year = RegnalYear.new
    regnal_year.number = number
    regnal_year.start_on = start_on
    regnal_year.reign = reign
  end
  
  # Because the "end date" for the last regal year updates daily, we always reset the end date.
  regnal_year.end_on = end_on
  regnal_year.save
end