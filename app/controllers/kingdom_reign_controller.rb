class KingdomReignController < ApplicationController

  def index
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    @reigns = @kingdom.reigns
    
    @page_title = "Reigns in the #{@kingdom.name}"
    
    # We check the format requested.
    respond_to do |format|
      
      # If the format requested was HTML ...
      format.html {
      
        # ... we set the page metadata.
        @multiline_page_title = "#{@kingdom.name} <span class='subhead'>Reigns</span>".html_safe
        @csv_url = kingdom_reign_list_url( :format => 'csv' )
        @description = "Reigns in the #{@kingdom.name}."
        @crumb << { label: 'Kingdoms', url: kingdom_list_url }
        @crumb << { label: @kingdom.name, url: kingdom_show_url }
        @crumb << { label: 'Reigns', url: nil }
        @section = 'kingdoms'
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
