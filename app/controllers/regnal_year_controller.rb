class RegnalYearController < ApplicationController
  
  def index
    @regnal_years = RegnalYear.find_by_sql(
      "
        SELECT ry.*, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, reigns r, monarchs m
        WHERE ry.reign_id = r.id
        AND r.monarch_id = m.id
        ORDER BY start_on
      "
    )
  end
  
  def show
    regnal_year = params[:regnal_year]
    @regnal_year = RegnalYear.find_by_sql(
      "
        SELECT ry.*, m.title AS monarch_title, m.id AS monarch_id, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, reigns r, monarchs m
        WHERE ry.reign_id = r.id
        AND r.monarch_id = m.id
        AND ry.id = #{regnal_year}
        ORDER BY start_on
      "
    ).first
    @page_title = @regnal_year.display_label
    @sessions = @regnal_year.sessions
  end
end
