# == Schema Information
#
# Table name: reigns
#
#  id         :integer          not null, primary key
#  end_on     :date
#  start_on   :date             not null
#  kingdom_id :integer          not null
#  monarch_id :integer          not null
#
# Foreign Keys
#
#  fk_kingdom  (kingdom_id => kingdoms.id)
#  fk_monarch  (monarch_id => monarchs.id)
#
class Reign < ApplicationRecord
  
  belongs_to :monarch
  
  def display_dates
    display_dates = self.start_on.strftime( $DATE_DISPLAY_FORMAT ) + ' - '
    display_dates += self.end_on.strftime( $DATE_DISPLAY_FORMAT ) if self.end_on
    display_dates
  end
  
  def display_title
    display_title = 'The reign of '
    display_title += self.monarch_title
    display_title += ' in the '
    display_title += self.kingdom_name
  end
end
