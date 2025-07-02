class MetaController < ApplicationController
  
  def index
    @page_title = 'About this application'
  end
  
  def schema
    @page_title = 'Database schema'
  end
  
  def cookies
    @page_title = 'Cookies'
  end
end
