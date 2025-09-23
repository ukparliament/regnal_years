class SessionRegnalYearController < ApplicationController

  def index
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

    # We set the page title.
    @page_title = "Regnal years during the #{@session.number.ordinalize} session of the #{@session.parliament_period_number.ordinalize} Parliament of the United Kingdom"
    
    # We check the format requested.
    respond_to do |format|
      
      # If the format requested was HTML ...
      format.html {
      
        # ... we set the page metadata.
        @multiline_page_title = "#{@session.number.ordinalize} session of the #{@session.parliament_period_number.ordinalize} Parliament of the United Kingdom <span class='subhead'>Regnal years</span>".html_safe
        @description = "Regnal years during the #{@session.number.ordinalize} session of the #{@session.parliament_period_number.ordinalize} Parliament of the United Kingdom."
        @csv_url = session_regnal_year_list_url( :format => 'csv' )
        @crumb << { label: 'Sessions', url: session_list_url }
        @crumb << { label: "#{@session.number.ordinalize} session of the #{@session.parliament_period_number.ordinalize} Parliament", url: session_show_url }
        @crumb << { label: 'Regnal years', url: nil }
        @section = 'sessions'
      }
      
      # If the format requested was CSV ...
      format.csv  {
        
        # ... we set the response header with a title.
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@page_title.downcase.gsub( ' ', '-' )}.csv\""
        render :template => 'regnal_year/index'
      }
    end
  end
end
