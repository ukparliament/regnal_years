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
end
