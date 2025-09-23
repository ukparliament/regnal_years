class RegnalYearSessionController < ApplicationController

  def index

    regnal_year = params[:regnal_year]
    @regnal_year = RegnalYear.find_by_sql([
      "
        SELECT ry.*, m.title AS monarch_title, m.id AS monarch_id, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, monarchs m
        WHERE ry.monarch_id = m.id
        AND ry.id = ?
        ORDER BY start_on
      ", regnal_year
    ]).first
    @sessions = @regnal_year.sessions
    
    # We set the page title.
    @page_title = "Sessions during #{@regnal_year.display_label}"
    
    
    # We check the format requested.
    respond_to do |format|
      
      # If the format requested was HTML ...
      format.html {
      
        # ... we set the page metadata.
        @multiline_page_title = "#{@regnal_year.display_label} <span class='subhead'>Sessions</span>".html_safe
        @description = "Sessions during #{@regnal_year.display_label}."
        @csv_url = regnal_year_session_list_url( :format => 'csv' )
        @crumb << { label: 'Regnal years', url: regnal_year_list_url }
        @crumb << { label: @regnal_year.display_label, url: regnal_year_show_url }
        @crumb << { label: 'Sessions', url: nil }
        @section = 'regnal-years'
      }
      
      # If the format requested was CSV ...
      format.csv  {
        
        # ... we set the response header with a title.
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@page_title.downcase.gsub( ' ', '-' )}.csv\""
        render :template => 'session/index'
      }
    end
  end
end
