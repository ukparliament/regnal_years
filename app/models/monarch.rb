class Monarch < ApplicationRecord
  
  def display_dates
    display_dates = self.date_of_birth.strftime( $DATE_DISPLAY_FORMAT ) + ' - '
    display_dates += self.date_of_death.strftime( $DATE_DISPLAY_FORMAT ) if self.date_of_death
    display_dates
  end
  
  def reigns
    Reign.find_by_sql( 
      "
        SELECT r.*, m.title AS monarch_title
        FROM REIGNS r, monarchs m
        WHERE r.monarch_id = m.id
        AND m.id = #{self.id}
        ORDER BY r.start_on
      "
    )
  end
end
