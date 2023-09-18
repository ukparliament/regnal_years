class CalculateController < ApplicationController
  
  def index
    date = params['date']
    
    # If a date string parameter has been passed ...
    if date
      
      # ... we try to parse the date string parameter as a date.
      begin
        @date = date.to_date
        
        # We raise an error if the date is in the future.
        @error_message = 'The date you entered is in the future.' if @date > Date.today
        
        # We raise an error if the date predates the UK.
        @error_message = 'The date you entered predates the existence of the United Kingdom.' if @date < '1801-01-01'.to_date
        
      # If the date string parameter cannot be parsed as a date ...
      rescue
        
        # ... we raise an error that the date is invalid.
        @error_message = 'You need to enter a valid date.'
      end
      
    # Otherwise, if no date string parameter has been passed ... 
    else
      
      # ... we raise an error that the date is missing.
      @error_message = 'You need to enter a date.'
    end
    
    # If we've raised an error ...
    if @error_message
      
      # ... we set the page title to error ...
      @page_title = "Unable to calculate a session citation"
      
      # ... and render the error template.
      render( :template => 'calculate/error' )
      
    # Otherwise, if we've not raised an error ... 
    else
      
      # We find the session this date is in.
      @session = Session.find_by_sql(
        "
          SELECT s.*, pp.number AS parliament_period_number
          FROM sessions s, parliament_periods pp
          WHERE s.parliament_period_id = pp.id
          AND s.start_on <= '#{@date}'
          AND s.end_on >= '#{@date}'
          ORDER BY start_on
        "
      ).first
      
      
      @page_title = "Regnal year session citation for #{@date.strftime( $DATE_DISPLAY_FORMAT )}"
    end
  end
end
