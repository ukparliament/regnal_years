class KingdomController < ApplicationController
  
  def index
    @kingdoms = Kingdom.all.order( 'end_on' ).order( 'name' )
    @page_title = 'Kingdoms'
  end
  
  def show
    kingdom = params[:kingdom]
    @kingdom = Kingdom.find( kingdom )
    @page_title = @kingdom.name
  end
end
