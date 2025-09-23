class ParliamentPeriodSessionController < ApplicationController

  def index
    parliament_period = params[:parliament_period]
    @parliament_period = ParliamentPeriod.find( parliament_period )
    @sessions = @parliament_period.sessions
  
    @page_title = "Sessions of the #{@parliament_period.number.ordinalize} Parliament of the United Kingdom"
    
    # We check the format requested.
    respond_to do |format|
      
      # If the format requested was HTML ...
      format.html {
      
        # ... we set the page metadata.
        @multiline_page_title = "#{@parliament_period.number.ordinalize} Parliament of the United Kingdom <span class='subhead'>Sessions</span>".html_safe
        @csv_url = parliament_period_session_list_url( :format => 'csv' )
        @description = "Sessions of the #{@parliament_period.number.ordinalize} Parliament of the United Kingdom."
        @crumb << { label: 'Parliament periods', url: parliament_period_list_url }
        @crumb << { label: @parliament_period.number.ordinalize, url: parliament_period_show_url }
        @crumb << { label: 'Sessions', url: nil }
        @section = 'parliaments'
      }
      
      # If the format requested was CSV ...
      format.csv  {
        
        # ... we set the response header with a title.
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@page_title.downcase.gsub( ' ', '-' )}.csv\""
      }
    end
  end
end
