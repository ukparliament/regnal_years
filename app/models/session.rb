class Session < ApplicationRecord
  
  def display_dates
    display_dates = self.start_on.strftime( $DATE_DISPLAY_FORMAT ) + ' - '
    display_dates += self.end_on.strftime( $DATE_DISPLAY_FORMAT ) if self.end_on
    display_dates
  end
  
  
  # ## A method to determine whether a session overlaps a regnal year.
  def overlaps_regnal_year?( regnal_year )
    
    # We sets overlaps regnal year to false.
    overlaps_regnal_year = false
    
    # If the session has an end date and the regnal year has an end date ...
    if self.end_on && regnal_year.end_on
    
      # If the regnal year starts on or before the end of the session and ends on or after the start of the session ...
      if regnal_year.start_on <= self.end_on && regnal_year.end_on >= self.start_on
        
        # ... we set overlaps regal year to true.
        overlaps_regnal_year = true
      end
      
    # Otherwise, if neither the session nor the regnal year have an end data ...
    elsif !self.end_on && !regnal_year.end_on
      
      # ... we must be in the latest session and the latest regnal year of the current reign, so we set overlaps regal year to true.
      overlaps_regnal_year = true
      
    # Otherwise, if the session has no end date but the regnal year does have an end date ...
    elsif !self.end_on && regnal_year.end_on
      
      # If the regnal year ends on or after the start of the session ...
      if regnal_year.end_on >= self.start_on
        
        # ... we set overlaps regal year to true.
        overlaps_regnal_year = true
      end
      
    end
    overlaps_regnal_year
  end
  
  def regnal_years
    RegnalYear.find_by_sql(
      "
        SELECT ry.*, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, reigns r, monarchs m, session_regnal_years sry
        WHERE ry.reign_id = r.id
        AND r.monarch_id = m.id
        AND ry.id = sry.regnal_year_id
        AND sry.session_id = #{self.id}
        ORDER BY start_on
      "
    )
  end
  
  # ## A method to calculate the regnal year citation for a session.
  def regnal_year_citation
    
    # We create a string to store the citation.
    citation = ''
    
    # We set the loop count to zero.
    loop_count = 0
    
    # We get all the regnal years for a session and store so we only query once.
    regnal_years = self.regnal_years
    
    # For each regnal year ...
    regnal_years.each do |regnal_year|
      
      # ... we increment the loop count by one.
      loop_count += 1
      
      # We calculate if this regnal year has preceding regnal years.
      has_preceding_regnal_years = ( loop_count - 1 != 0 )
      
      # We calculate if this regnal year has following regnal years.
      has_following_regnal_years = ( loop_count != regnal_years.size )
      
      # We add the number of the regnal year to the citation.
      citation += regnal_year.number.to_s
      
      # If the regnal year does not have any following regnal years.
      unless has_following_regnal_years
        
        # ... we add the monarch to the citation.
        citation += ' ' + regnal_year.monarch_abbreviation + ' '
        
      # Otherwise, if the regnal year does have following regnal years ...
      else
        
        # If the next regnal year has a different monarch to this regnal year ...
        if regnal_years[loop_count].monarch_abbreviation != regnal_year.monarch_abbreviation
          
          # ... we add the monarch to the citation.
          citation += regnal_year.monarch_abbreviation + ', '
          
        # Otherwise, if the next regnal year has the same monarch as this regnal year ... 
        else
          
          # If regnal years array extends past the next regnal year ...
          if regnal_years.size > loop_count + 1
            
            # ... we separate the regnal year numbers with a comma.
            citation += ',  '
          else
            
            # ... we separate the regnal year numbers with an ampersand.
            citation += ' &  '
          end
        end
      end
    end
    
    # If the session overlaps a single regnal year ...
    if regnal_years.size == 1
      
      # ... we get all the sessions for a regnal year and store so we only query once.
      sessions = regnal_years[0].sessions
      
      # If the count of sessions for a regnal year is greater than one ...
      if sessions.size > 1
        
        # We set the loop count to zero.
        loop_count = 0
      
        # For each session overlapping a regnal year ...
        sessions.each do |session|
      
          # ... we increment the loop count by one.
          loop_count += 1
        
          # If the session is this session ...
          if session == self
          
            # We append the session number to the citation.
            citation += ' (Sess. ' + loop_count.to_s + ')'
          end
        end
      end
    end
    citation
  end
  
  def previous
    Session.all.where( "start_on < ?", self.start_on ).order( 'start_on desc' ).first
  end
  
  def next
    Session.all.where( "start_on > ?", self.start_on ).order( 'start_on' ).first
  end
end
