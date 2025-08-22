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
    @page_title = 'Regnal years'
    @description = 'Regnal years.'
    @crumb << { label: @page_title, url: nil }
    @section = 'regnal-years'
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
    @sessions = @regnal_year.sessions
    @previous_regnal_year = @regnal_year.previous
    @next_regnal_year = @regnal_year.next
    
    @page_title = @regnal_year.display_label
    @description = "#{@regnal_year.display_label}."
    @crumb << { label: 'Regnal years', url: regnal_year_list_url }
    @crumb << { label: @page_title, url: nil }
    @section = 'regnal-years'
    @previous_url = regnal_year_show_url( :regnal_year => @previous_regnal_year ) if @previous_regnal_year
    @next_url = regnal_year_show_url( :regnal_year => @next_regnal_year ) if @next_regnal_year
  end
end
