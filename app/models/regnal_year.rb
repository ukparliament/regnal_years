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
end
