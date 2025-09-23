class SessionController < ApplicationController
  
  def index
    @sessions = Session.find_by_sql(
      "
        SELECT s.*, pp.number AS parliament_period_number
        FROM sessions s, parliament_periods pp
        WHERE s.parliament_period_id = pp.id
        ORDER BY start_on
      "
    )
    
    @page_title = 'Sessions'
    @description = 'Sessions of the UK Parliament.'
    @csv_url = session_list_url( :format => 'csv' )
    @crumb << { label: @page_title, url: nil }
    @section = 'sessions'
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
    @regnal_years = @session.regnal_years
    @previous_session = @session.previous
    @next_session = @session.next

    @page_title = "#{@session.number.ordinalize} session of the #{@session.parliament_period_number.ordinalize} Parliament of the United Kingdom"
    @description = "#{@session.number.ordinalize} session of the #{@session.parliament_period_number.ordinalize} Parliament of the United Kingdom."
    @crumb << { label: 'Sessions', url: session_list_url }
    @crumb << { label: "#{@session.number.ordinalize} session of the #{@session.parliament_period_number.ordinalize} Parliament", url: nil }
    @section = 'sessions'
    @previous_url = session_show_url( :session => @previous_session ) if @previous_session
    @next_url = session_show_url( :session => @next_session ) if @next_session
  end
end
