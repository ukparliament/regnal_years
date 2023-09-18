class RegnalYear < ApplicationRecord
  
  belongs_to :reign
  
  def display_dates
    display_dates = self.start_on.strftime( $DATE_DISPLAY_FORMAT ) + ' - '
    display_dates += self.end_on.strftime( $DATE_DISPLAY_FORMAT ) if self.end_on
    display_dates
  end
  
  def display_label
    display_label = self.number.to_s
    display_label += ' ' + self.monarch_abbreviation
    display_label
  end
  
  def sessions
    Session.find_by_sql(
      "
        SELECT s.*, pp.number AS parliament_period_number
        FROM sessions s, parliament_periods pp, session_regnal_years sry
        WHERE s.parliament_period_id = pp.id
        AND s.id = sry.session_id
        AND sry.regnal_year_id = #{self.id}
        ORDER BY start_on
      "
    )
  end
end
