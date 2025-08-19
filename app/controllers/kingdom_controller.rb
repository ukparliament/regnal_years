class KingdomController < ApplicationController
  
  def index
    @kingdoms = Kingdom.all.order( 'end_on' ).order( 'name' )
    @page_title = 'Kingdoms'
    @description = 'Kingdoms.'
    @crumb << { label: @page_title, url: nil }
    @section = 'kingdoms'
  end
  
  def show
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    @page_title = @kingdom.name
    @description = "#{@kingdom.name}."
    @crumb << { label: 'Kingdoms', url: kingdom_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'kingdoms'
  end
end
