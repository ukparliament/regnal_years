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
end
