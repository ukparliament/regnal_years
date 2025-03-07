# == Schema Information
#
# Table name: sessions
#
#  id                      :integer          not null, primary key
#  calendar_years_citation :string(50)       not null
#  end_on                  :date
#  number                  :integer          not null
#  regnal_years_citation   :string(50)
#  start_on                :date             not null
#  parliament_period_id    :integer          not null
#  wikidata_id             :string(20)
#
# Foreign Keys
#
#  fk_parliament_period  (parliament_period_id => parliament_periods.id)
#
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
    
      # ... if the regnal year starts on or before the end of the session and ends on or after the start of the session ...
      if regnal_year.start_on <= self.end_on && regnal_year.end_on >= self.start_on
        
        # ... we set overlaps regal year to true.
        overlaps_regnal_year = true
      end
      
    # Otherwise, if the session has no end date but the regnal year does have an end date ...
    elsif !self.end_on && regnal_year.end_on
      
      # ... we must be in the latest session but not the latest regnal year.
      # If the regnal year ends on or after the start of the session ...
      if regnal_year.end_on >= self.start_on
        
        # ... we set overlaps regal year to true.
        overlaps_regnal_year = true
      end
      
    # Otherwise, if the session has an end date but the regnal year does not have an end date ...
    elsif self.end_on && !regnal_year.end_on
      
      # ... we must be in the latest regnal year, but not the lastest session.
      # If the regnal year starts on or before the end of the session ...
      if regnal_year.start_on <= self.end_on
        
        # ... we set overlaps regal year to true.
        overlaps_regnal_year = true
      end
      
    # Otherwise, if neither the session nor the regnal year have an end data ...
    elsif !self.end_on && !regnal_year.end_on
      
      # ... we must be in the latest session and the latest regnal year.
      # @e set overlaps regal year to true.
      overlaps_regnal_year = true
    end
    overlaps_regnal_year
  end
  
  def regnal_years
    RegnalYear.find_by_sql(
      "
        SELECT ry.*, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, monarchs m, session_regnal_years sry
        WHERE ry.monarch_id = m.id
        AND ry.id = sry.regnal_year_id
        AND sry.session_id = #{self.id}
        ORDER BY start_on
      "
    )
  end
  
  def previous
    Session.all.where( "start_on < ?", self.start_on ).order( 'start_on desc' ).first
  end
  
  def next
    Session.all.where( "start_on > ?", self.start_on ).order( 'start_on' ).first
  end
end
