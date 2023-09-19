class ParliamentPeriodController < ApplicationController
  
  def index
    @page_title = 'Parliament periods'
    @parliament_periods = ParliamentPeriod.all.order( 'start_on' )
  end
  
  def show
    parliament_period = params[:parliament_period]
    @parliament_period = ParliamentPeriod.find( parliament_period )
    @page_title = "#{@parliament_period.number.ordinalize} Parliament of the United Kingdom"
    @sessions = @parliament_period.sessions
    @previous_parliament_period = @parliament_period.previous
    @next_parliament_period = @parliament_period.next
  end
end
