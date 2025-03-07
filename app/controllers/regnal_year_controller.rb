class RegnalYearController < ApplicationController
  
  def index
    @regnal_years = RegnalYear.find_by_sql(
      "
        SELECT ry.*, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, monarchs m
        WHERE ry.monarch_id = m.id
        ORDER BY start_on
      "
    )
  end
  
  def show
    regnal_year = params[:regnal_year]
    @regnal_year = RegnalYear.find_by_sql([
      "
        SELECT ry.*, m.title AS monarch_title, m.id AS monarch_id, m.abbreviation AS monarch_abbreviation
        FROM regnal_years ry, monarchs m
        WHERE ry.monarch_id = m.id
        AND ry.id = ?
        ORDER BY start_on
      ", regnal_year
    ]).first

    @page_title = @regnal_year.display_label
    @sessions = @regnal_year.sessions
    @previous_regnal_year = @regnal_year.previous
    @next_regnal_year = @regnal_year.next
  end
end
