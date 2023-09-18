require 'csv'

task :setup => [
  :import_monarchs,
  :import_reigns,
  :generate_regnal_years,
  :import_parliament_periods,
  :import_sessions,
  :generate_regnal_year_sessions
]

# ## A task to import monarchs.
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

# ## A task to import reigns.
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

# ## A task to generate regnal years.
task :generate_regnal_years => :environment do
  puts "generating regnal years"
  reigns = Reign.all.order( 'start_on' )
  reigns.each do |reign|
    
    # We set the regnal year number in this reign to one.
    regnal_year_number = 1
    
    # We set the start date of the first regnal year to the start date of the reign.
    regnal_year_start_on = reign.start_on
    
    # If the reign has an end date ...
    if reign.end_on
      
      # ... if the start date of the reign plus a year minus a day is greater than the end date of the reign ...
      if reign.start_on + 1.year - 1.day > reign.end_on
      
        # ... we set the end date of the first regnal year to the end date of the reign.
        regnal_year_end_on = reign.end_on
      
      # Otherwise, if the start date of the reign plus a year minus a day is not greater than the end date of the reign ...
      else
      
        # ... we set the end date of the first regnal year to the start date of the reign plus a year minus a day.
        regnal_year_end_on = reign.start_on  + 1.year - 1.day
      end
      
    # Otherwise, if the reign has no end date ...
    else
      
      # ... if the start date of the reign plus a year minus a day is greater than today ...
      if reign.start_on + 1.year - 1.day > Date.today
      
        # ... we set the end date of the first regnal year to nil.
        regnal_year_end_on = nil
      
      # Otherwise, if the start date of the reign plus a year minus a day is not greater than today ...
      else
      
        # ... we set the end date of the first regnal year to the start date of the reign plus a year minus a day.
        regnal_year_end_on = reign.start_on  + 1.year - 1.day
      end
    end
    
    # We create the first regnal year.
    find_or_create_regnal_year( reign, regnal_year_number, regnal_year_start_on, regnal_year_end_on )
    
    # Whilst the end date of the regnal year does not equal the end date of the reign and whilst the end date of the regnal year is not nil ...
    while regnal_year_end_on != reign.end_on and regnal_year_end_on != nil
      
      # ... we increment the regnal year number.
      regnal_year_number += 1
      
      # We increment the regnal year start date by one year.
      regnal_year_start_on += 1.year
      
      # If the reign has an end date ...
      if reign.end_on
      
        # ... if the start date of the regnal year plus a year minus a day is greater than the end date of the reign ...
        if regnal_year_start_on + 1.year - 1.day > reign.end_on
      
          # ... we set the end date of the regnal year to the end date of the reign.
          regnal_year_end_on = reign.end_on
      
        # Otherwise, if the start date of the regnal year plus a year minus a day is not greater than the end date of the reign ...
        else
      
          # ... we set the end date of the regnal year to the start date of the regnal year plus a year minus a day.
          regnal_year_end_on = regnal_year_start_on  + 1.year - 1.day
        end
      
      # Otherwise, if the reign has no end date ...
      else
      
        # ... if the start date of the regnal year plus a year minus a day is greater than today ...
        if regnal_year_start_on + 1.year - 1.day > Date.today
      
          # ... we set the end date of the regnal year to today.
          regnal_year_end_on = nil
      
        # Otherwise, if the start date of the regnal year plus a year minus a day is not greater than today ...
        else
      
          # ... we set the end date of the regnal year to the start date of the regnal year plus a year minus a day.
          regnal_year_end_on = regnal_year_start_on  + 1.year - 1.day
        end
      end
      
      # We create the next regnal year.
      find_or_create_regnal_year( reign, regnal_year_number, regnal_year_start_on, regnal_year_end_on )
     end
   end
end

# ## A task to import parliament periods.
task :import_parliament_periods => :environment do
  puts "importing parliament periods"
  CSV.foreach( 'db/data/parliaments.csv' ) do |row|
    parliament_period = ParliamentPeriod.new
    parliament_period.id = row[0]
    parliament_period.number = row[0]
    parliament_period.start_on = row[2]
    parliament_period.end_on = row[4]
    parliament_period.wikidata_id = row[5]
    parliament_period.save
  end
end

# ## A task to import sessions.
task :import_sessions => :environment do
  puts "importing sessions"
  CSV.foreach( 'db/data/sessions.csv' ) do |row|
    session = Session.new
    session.number = row[1]
    session.start_on = row[2]
    session.end_on = row[3]
    session.citation = row[4]
    session.parliament_period_id = row[0]
    session.save
  end
end

# ## A task to generate regnal year sessions.
task :generate_regnal_year_sessions => :environment do
  puts "generating regnal year sessions"
  
  # We get all the sessions ...
  sessions = Session.all.order( 'start_on' )
  
  # ... and all the regnal years.
  regnal_years = RegnalYear.all.order( 'start_on' )
  
  # For each session ...
  sessions.each do |session|
    
    # ... and for each regnal year ...
    regnal_years.each do |regnal_year|
      
      # ... if the session overlaps the regnal year ...
      if session.overlaps_regnal_year?( regnal_year )
        
        # ... we create a new session regnal year.
        session_regnal_year = SessionRegnalYear.new
        session_regnal_year.session = session
        session_regnal_year.regnal_year = regnal_year
        session_regnal_year.save
      end
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
    regnal_year.end_on = end_on
    regnal_year.reign = reign
    regnal_year.save
  end
end