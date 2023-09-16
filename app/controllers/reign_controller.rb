class ReignController < ApplicationController
  
  def index
    @page_title = 'Reigns'
    @reigns = Reign.all.order( 'start_on' )
    
    @reigns = Reign.find_by_sql( 
      "
        SELECT r.*, m.title AS monarch_title
        FROM REIGNS r, monarchs m
        WHERE r.monarch_id = m.id
        ORDER BY r.start_on
      "
    )
  end
  
  def show
    reign = params[:reign]
    @reign = Reign.find_by_sql( 
      "
        SELECT r.*, m.title AS monarch_title
        FROM REIGNS r, monarchs m
        WHERE r.monarch_id = m.id
        AND r.id = #{reign}
        ORDER BY r.start_on
      "
    ).first
    @page_title = @reign.display_title
  end
end
