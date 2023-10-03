require 'csv'

task :setup => [
  :import_kingdoms,
  :import_monarchs,
  :import_reigns,
  :generate_regnal_years,
  :import_parliament_periods,
  :import_sessions,
  :generate_regnal_year_sessions,
  :generate_session_regnal_year_citations,
  :generate_session_numbers_for_regnal_year_citations
]

# ## A task to import kingdoms.
task :import_kingdoms => :environment do
  puts "importing kingdoms"
  CSV.foreach( 'db/data/kingdoms.csv' ) do |row|
    kingdom = Kingdom.new
    kingdom.id = row[0]
    kingdom.name = row[1]
    kingdom.start_on = row[2]
    kingdom.end_on = row[3]
    kingdom.save
  end
end

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
    reign.kingdom_id = row[4]
    reign.monarch_id = row[0]
    reign.save
  end
end

# ## A task to generate regnal years.
task :generate_regnal_years => :environment do
  puts "generating regnal years"
  
  # We get all the monarchs.
  monarchs = Monarch.all.order( 'date_of_birth' )
  
  # For each monarch ...
  monarchs.each do |monarch|
    
    # .. we set the regnal year number of this monarch to one.
    regnal_year_number = 1
    
    # We get the earliest reign start on for this monarch.
    earliest_reign_start_on = monarch.earliest_reign_start_on
    
    # We get the latest reign end on for this monarch.
    latest_reign_end_on = monarch.latest_reign_end_on
    
    # We set the start date of the regnal year to the start date of the reign(s).
    regnal_year_start_on = earliest_reign_start_on
    
    # If the reign(s) have an end date ...
    if latest_reign_end_on
      
      # ... if the start date of the reign(s) plus a year minus a day is greater than the end date of the reign(s) ...
      if earliest_reign_start_on + 1.year - 1.day > latest_reign_end_on
      
        # ... we set the end date of the first regnal year to the end date of the reign(s).
        regnal_year_end_on = latest_reign_end_on
      
      # Otherwise, if the start date of the reign(s) plus a year minus a day is not greater than the end date of the reign(s) ...
      else
      
        # ... we set the end date of the first regnal year to the start date of the reign(s) plus a year minus a day.
        regnal_year_end_on = earliest_reign_start_on  + 1.year - 1.day
      end
      
    # Otherwise, if the reign(s) have no end date ...
    else
      
      # ... if the start date of the reign(s) plus a year minus a day is greater than today ...
      if earliest_reign_start_on + 1.year - 1.day > Date.today
      
        # ... we set the end date of the first regnal year to nil.
        regnal_year_end_on = nil
      
      # Otherwise, if the start date of the reign(s) plus a year minus a day is not greater than today ...
      else
      
        # ... we set the end date of the first regnal year to the start date of the reign(s) plus a year minus a day.
        regnal_year_end_on = earliest_reign_start_on + 1.year - 1.day
      end
    end
    
    # We create the first regnal year.
    find_or_create_regnal_year( monarch, regnal_year_number, regnal_year_start_on, regnal_year_end_on )
    
    # Whilst the end date of the regnal year does not equal the end date of the reign(s) and whilst the end date of the regnal year is not nil ...
    while regnal_year_end_on != latest_reign_end_on and regnal_year_end_on != nil
      
      # ... we increment the regnal year number.
      regnal_year_number += 1
      
      # We increment the regnal year start date by one year.
      regnal_year_start_on += 1.year
      
      # If the reign(s) have an end date ...
      if latest_reign_end_on
          
        # ... if the start date of the regnal year plus a year minus a day is greater than the end date of the reign(s) ...
        if regnal_year_start_on + 1.year - 1.day > latest_reign_end_on
      
          # ... we set the end date of the regnal year to the end date of the reign(s).
          regnal_year_end_on = latest_reign_end_on
      
        # Otherwise, if the start date of the regnal year plus a year minus a day is not greater than the end date of the reign(s) ...
        else
      
          # ... we set the end date of the regnal year to the start date of the regnal year plus a year minus a day.
          regnal_year_end_on = regnal_year_start_on  + 1.year - 1.day
        end
      
      # Otherwise, if the reign(s) have no end date ...
      else
      
        # ... if the start date of the regnal year plus a year minus a day is greater than today ...
        if regnal_year_start_on + 1.year - 1.day > Date.today
      
          # ... we set the end date of the regnal year to nil.
          regnal_year_end_on = nil
      
        # Otherwise, if the start date of the regnal year plus a year minus a day is not greater than today ...
        else
      
          # ... we set the end date of the regnal year to the start date of the regnal year plus a year minus a day.
          regnal_year_end_on = regnal_year_start_on  + 1.year - 1.day
        end
      end
      
      # We create the next regnal year.
      find_or_create_regnal_year( monarch, regnal_year_number, regnal_year_start_on, regnal_year_end_on )
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
    session.wikidata_id = row[6]
    session.calendar_years_citation = row[4]
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

# ## A task to generate session regnal year citations.
task :generate_session_regnal_year_citations => :environment do
  puts "generating session regnal year citations"
  
  # We get all the sessions ...
  sessions = Session.all.order( 'start_on' )
  
  # For each session ...
  sessions.each do |session|
    
    # ... we create a string to store the citation.
    citation = ''
    
    # We set the loop count to zero.
    loop_count = 0
    
    # We get all the regnal years for the session and store so we only query once.
    regnal_years = session.regnal_years
    
    # For each regnal year ...
    regnal_years.each do |regnal_year|
      
      # ... we increment the loop count by one.
      loop_count += 1
      
      # We calculate if this regnal year has preceding regnal years.
      has_preceding_regnal_years = ( loop_count - 1 != 0 )
      
      # We calculate if this regnal year has following regnal years.
      has_following_regnal_years = ( loop_count != regnal_years.size )
      
      # We add the number of the regnal year to the citation.
      citation += ' ' + regnal_year.number.to_s
      
      # If the regnal year does not have any following regnal years.
      unless has_following_regnal_years
        
        # ... we add the monarch to the citation.
        citation += ' ' + regnal_year.monarch_abbreviation
        
      # Otherwise, if the regnal year does have following regnal years ...
      else
        
        # If the next regnal year has a different monarch to this regnal year ...
        if regnal_years[loop_count].monarch_abbreviation != regnal_year.monarch_abbreviation
          
          # ... we add the monarch to the citation.
          citation += ' ' + regnal_year.monarch_abbreviation + ' &'
          
        # Otherwise, if the next regnal year has the same monarch as this regnal year ... 
        else
          
          # If regnal years array extends past the next regnal year ...
          if regnal_years.size > loop_count + 1
            
            # ... if the next but one regnal year has the same monarch ...
            if regnal_years[loop_count + 1].monarch_abbreviation == regnal_year.monarch_abbreviation
              
              # ... we separate the regnal year numbers with a comma.
              citation += ','
              
              # Otherise, if the next but one regnal year does not have the same monarch ...
            else
              
              # ... we separate the regnal year numbers with a comma.
              citation += ' &'
            end
            
          # Otherwise, if the next regnal year is the last regnal year ...
          else
            
            # ... we separate the regnal year numbers with an ampersand.
            citation += ' &'
          end
        end
      end
    end
    
    # We store the regnal years citation - stripped of any leading and trailing spaces - on the session.
    session.regnal_years_citation = citation.strip
    session.save
  end
end

# ## A method to append session number disambiguation to session regnal year citations.
task :generate_session_numbers_for_regnal_year_citations => :environment do
  puts "generating session numbers for regnal year citations"
  
  # We get all duplicate regnal years citations from the sessions table.
  duplicate_regnal_years_citations = Session.find_by_sql(
    "
      SELECT regnal_years_citation
      FROM sessions
      GROUP BY regnal_years_citation
      HAVING count(id) > 1;
    "
  )
  
  # For each duplicate regnal years citation in the sessions table ...
  duplicate_regnal_years_citations.each do |duplicate_regnal_years_citation|
    
    # ... we find the sessions with that regnal years citation.
    sessions = Session.find_by_sql(
      "
        SELECT *
        FROM sessions
        WHERE regnal_years_citation = '#{duplicate_regnal_years_citation.regnal_years_citation}'
        ORDER BY start_on
      "
    )
    
    # We set the count attribute to zero.
    count = 0
    
    # For each session ...
    sessions.each do |session|
      
      # ... we increment the count.
      count += 1
      
      # We append the session count to the regnal years citation ...
      session.regnal_years_citation += " (sess. #{count})"
      
      # ... and save the session.
      session.save
    end
  end
end



# ## A method to find or create a regnal year.
def find_or_create_regnal_year( monarch, number, start_on, end_on )
  
  # We attempt to find a regnal year for this monarch, with this number.
  regnal_year = RegnalYear
    .all
    .where( "monarch_id = ?", monarch.id )
    .where( "start_on = ?", start_on )
    .where( "end_on = ?", end_on )
    .first
  
  # Unless we find the regnal year ...
  unless regnal_year
    
    # ... we create a new regnal year.
    regnal_year = RegnalYear.new
    regnal_year.number = number
    regnal_year.start_on = start_on
    regnal_year.end_on = end_on
    regnal_year.monarch = monarch
    regnal_year.save
  end
end