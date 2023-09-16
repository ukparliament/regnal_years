class ParliamentPeriod < ApplicationRecord
  
  def display_dates
    display_dates = self.start_on.strftime( $DATE_DISPLAY_FORMAT ) + ' - '
    display_dates += self.end_on.strftime( $DATE_DISPLAY_FORMAT ) if self.end_on
    display_dates
  end
  
  def sessions
    @sessions = Session.find_by_sql(
      "
        SELECT s.*, pp.number AS parliament_period_number
        FROM sessions s, parliament_periods pp
        WHERE s.parliament_period_id = pp.id
        AND s.parliament_period_id = #{self.id}
        ORDER BY start_on
      "
    )
  end
end
