class ReignController < ApplicationController
  
  def index
    @page_title = 'Reigns'
    
    @reigns = Reign.find_by_sql( 
      "
        SELECT r.*, k.name AS kingdom_name, m.title AS monarch_title
        FROM REIGNS r, monarchs m, kingdoms k
        WHERE r.monarch_id = m.id
        AND r.kingdom_id = k.id
        ORDER BY r.start_on
      "
    )
    
    @page_title = 'Reigns'
    @description = 'Reigns.'
    @csv_url = reign_list_url( :format => 'csv' )
    @crumb << { label: @page_title, url: nil }
    @section = 'reigns'
  end
  
  def show
    reign_id = params[:reign]
    @reign = Reign.find_by_sql([
      "
        SELECT r.*, k.name AS kingdom_name, m.title AS monarch_title
        FROM reigns r, monarchs m, kingdoms k
        WHERE r.monarch_id = m.id
        AND r.kingdom_id = k.id
        AND r.id = ?
        ORDER BY r.start_on
      ", reign_id
    ]).first

    @page_title = @reign.display_title
    @description = "#{@reign.display_title}."
    @crumb << { label: 'Reigns', url: reign_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'reigns'
  end
end
