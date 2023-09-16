class Reign < ApplicationRecord
  
  belongs_to :monarch
  
  def display_dates
    display_dates = self.start_on.strftime( $DATE_DISPLAY_FORMAT ) + ' - '
    display_dates += self.end_on.strftime( $DATE_DISPLAY_FORMAT ) if self.end_on
    display_dates
  end
  
  def display_title
    display_title = self.monarch_title
    display_title += ' (' + self.display_dates + ')'
  end
  
  def regnal_years
    RegnalYear.find_by_sql(
      "
        SELECT ry.*, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, reigns r, monarchs m
        WHERE ry.reign_id = r.id
        AND r.monarch_id = m.id
        AND r.id = #{self.id}
        ORDER BY start_on
      "
    )
  end
end
