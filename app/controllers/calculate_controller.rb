class CalculateController < ApplicationController
  
  def index
    date = params['date']
    if date
      begin
        @date = date.to_date
        @error_message = 'The date you entered is in the future.' if @date > Date.today
        @error_message = 'The date you entered predates the existence of the United Kingdom.' if @date < '1801-01-01'.to_date
      rescue
        @error_message = 'You need to enter a valid date.'
      end
    else
      @error_message = 'You need to enter a date.'
    end
    if @error_message
      @page_title = "Unable to calculate a session citation"
      render( :template => 'calculate/error' )
    else
      @page_title = "Regnal year session citation for #{@date.strftime( $DATE_DISPLAY_FORMAT )}"
    end
  end
end
