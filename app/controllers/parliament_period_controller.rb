class ParliamentPeriodController < ApplicationController
  
  def index
    @parliament_periods = ParliamentPeriod.all.order( 'start_on' )
    
    @page_title = 'Parliament periods'
    @description = 'UK Parliament periods.'
    @csv_url = parliament_period_list_url( :format => 'csv' )
    @crumb << { label: @page_title, url: nil }
    @section = 'parliaments'
  end
  
  def show
    parliament_period = params[:parliament_period]
    @parliament_period = ParliamentPeriod.find( parliament_period )
    @sessions = @parliament_period.sessions
    @previous_parliament_period = @parliament_period.previous
    @next_parliament_period = @parliament_period.next
    
    @page_title = "#{@parliament_period.number.ordinalize} Parliament of the United Kingdom"
    @description = "#{@parliament_period.number.ordinalize} Parliament of the United Kingdom."
    @crumb << { label: 'Parliament periods', url: parliament_period_list_url }
    @crumb << { label: @parliament_period.number.ordinalize, url: nil }
    @section = 'parliaments'
    @previous_url = parliament_period_show_url( :parliament_period => @previous_parliament_period ) if @previous_parliament_period
    @next_url = parliament_period_show_url( :parliament_period => @next_parliament_period ) if @next_parliament_period
  end
end
