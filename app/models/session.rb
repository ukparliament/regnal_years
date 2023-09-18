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
  
  def regnal_year_citation
    'this is the citation'
  end
end
