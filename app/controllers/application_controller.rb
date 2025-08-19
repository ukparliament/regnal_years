class ApplicationController < ActionController::Base

  include LibraryDesign::Crumbs
  
  $SITE_TITLE = 'UK Parliament Session Citations'
  
  $DATE_DISPLAY_FORMAT = '%-d %B %Y'
end
