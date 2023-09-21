class ReignController < ApplicationController
  
  def index
    @page_title = 'Reigns'
    @reigns = Reign.all.order( 'start_on' )
    
    @reigns = Reign.find_by_sql( 
      "
        SELECT r.*, k.name AS kingdom_name, m.title AS monarch_title
        FROM REIGNS r, monarchs m, kingdoms k
        WHERE r.monarch_id = m.id
        AND r.kingdom_id = k.id
        ORDER BY r.start_on
      "
    )
  end
  
  def show
    reign = params[:reign]
    @reign = Reign.find_by_sql( 
      "
        SELECT r.*, k.name AS kingdom_name, m.title AS monarch_title
        FROM reigns r, monarchs m, kingdoms k
        WHERE r.monarch_id = m.id
        AND r.kingdom_id = k.id
        AND r.id = #{reign}
        ORDER BY r.start_on
      "
    ).first
    @page_title = @reign.display_title
  end
end
