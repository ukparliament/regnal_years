# == Schema Information
#
# Table name: parliament_periods
#
#  id          :integer          not null, primary key
#  end_on      :date
#  number      :integer          not null
#  start_on    :date             not null
#  wikidata_id :string(20)
#
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
  
  def previous
    ParliamentPeriod.all.where( "start_on < ?", self.start_on ).order( 'start_on desc' ).first
  end
  
  def next
    ParliamentPeriod.all.where( "start_on > ?", self.start_on ).order( 'start_on' ).first
  end
end
