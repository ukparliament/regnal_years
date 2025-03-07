class SessionController < ApplicationController
  
  def index
    @page_title = 'Sessions'
    @sessions = Session.find_by_sql(
      "
        SELECT s.*, pp.number AS parliament_period_number
        FROM sessions s, parliament_periods pp
        WHERE s.parliament_period_id = pp.id
        ORDER BY start_on
      "
    )
  end
  
  def show
    session_id = params[:session]
    @session = Session.find_by_sql([
      "
        SELECT s.*, pp.number AS parliament_period_number
        FROM sessions s, parliament_periods pp
        WHERE s.parliament_period_id = pp.id
        AND s.id = ?
        ORDER BY start_on
      ", session_id
    ]).first

    @page_title = "#{@session.number.ordinalize} session of the #{@session.parliament_period_number.ordinalize} Parliament of the United Kingdom"
    @regnal_years = @session.regnal_years
    @previous_session = @session.previous
    @next_session = @session.next
  end
end
