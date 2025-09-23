class MonarchReignController < ApplicationController

  def index
    monarch = params[:monarch]
    @monarch = Monarch.find( monarch )
    @reigns = @monarch.reigns
    
    @page_title = "Reigns of #{@monarch.title}"
    
    # We check the format requested.
    respond_to do |format|
      
      # If the format requested was HTML ...
      format.html {
      
        # ... we set the page metadata.
        @multiline_page_title = "#{@monarch.title} <span class='subhead'>Reigns</span>".html_safe
        @csv_url = monarch_reign_list_url( :format => 'csv' )
        @description = "Reigns of #{@monarch.title}."
        @crumb << { label: 'Monarchs', url: monarch_list_url }
        @crumb << { label: @monarch.title, url: monarch_show_url }
        @crumb << { label: 'Reigns', url: nil }
        @section = 'monarchs'
      }
      
      # If the format requested was CSV ...
      format.csv  {
        
        # ... we set the response header with a title.
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@page_title.downcase.gsub( ' ', '-' )}.csv\""
        render :template => 'reign/index'
      }
    end
  end
end
