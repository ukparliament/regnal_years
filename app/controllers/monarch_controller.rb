class MonarchController < ApplicationController
  
  def index
    @page_title = 'Monarchs'
    @monarchs = Monarch.all.order( 'date_of_birth' )
  end
  
  def show
    monarch = params[:monarch]
    @monarch = Monarch.find( monarch )
    @page_title = @monarch.title
  end
end
