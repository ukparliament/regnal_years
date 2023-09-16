class RegnalYear < ApplicationRecord
  
  belongs_to :reign
  
  def display_label
    display_label = self.number.to_s
    display_label += ' ' + self.monarch_abbreviation
    display_label
  end
end
