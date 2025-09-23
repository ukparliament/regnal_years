class MonarchController < ApplicationController
  
  def index
    @monarchs = Monarch.all.order( 'date_of_birth' )
    @page_title = 'Monarchs'
    @description = 'Monarchs.'
    @csv_url = monarch_list_url( :format => 'csv' )
    @crumb << { label: @page_title, url: nil }
    @section = 'monarchs'
  end
  
  def show
    monarch = params[:monarch]
    @monarch = Monarch.find( monarch )
    
    @reigns = @monarch.reigns
    @regnal_years = @monarch.regnal_years
    
    @page_title = @monarch.title
    @description = "#{@monarch.title}."
    @crumb << { label: 'Monarchs', url: monarch_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'monarchs'
  end
end
