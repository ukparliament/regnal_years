class Monarch < ApplicationRecord
  
  def display_dates
    display_dates = self.date_of_birth.strftime( $DATE_DISPLAY_FORMAT ) + ' - '
    display_dates += self.date_of_death.strftime( $DATE_DISPLAY_FORMAT ) if self.date_of_death
    display_dates
  end
  
  def reigns
    Reign.find_by_sql( 
      "
        SELECT r.*, k.name AS kingdom_name, m.title AS monarch_title
        FROM REIGNS r, monarchs m, kingdoms k
        WHERE r.monarch_id = m.id
        AND r.kingdom_id = k.id
        AND m.id = #{self.id}
        ORDER BY r.start_on
      "
    )
  end
  
  def regnal_years
    @regnal_years = RegnalYear.find_by_sql(
      "
        SELECT ry.*, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, monarchs m
        WHERE ry.monarch_id = m.id
        AND m.id = #{self.id}
        ORDER BY start_on
      "
    )
  end
end
