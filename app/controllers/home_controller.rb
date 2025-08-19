class HomeController < ApplicationController
  
  def index
    @page_title = 'UK Parliament session citations'
    @description = 'Session citations for the UK Parliament'
  end
end
