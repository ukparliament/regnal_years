# == Schema Information
#
# Table name: kingdoms
#
#  id       :integer          not null, primary key
#  end_on   :date
#  name     :string(255)      not null
#  start_on :date
#
class Kingdom < ApplicationRecord
  
  def display_dates
    display_dates = ''
    display_dates = self.start_on.strftime( $DATE_DISPLAY_FORMAT ) if self.start_on
    display_dates += ' - '
    display_dates += self.end_on.strftime( $DATE_DISPLAY_FORMAT ) if self.end_on
    display_dates
  end
  
  def reigns
    Reign.find_by_sql( 
      "
        SELECT r.*, k.name AS kingdom_name, m.title AS monarch_title
        FROM REIGNS r, monarchs m, kingdoms k
        WHERE r.monarch_id = m.id
        AND r.kingdom_id = k.id
        AND k.id = #{self.id}
        ORDER BY r.start_on
      "
    )
  end
end
