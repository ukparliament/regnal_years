task :update => [ 
  :generate_regnal_years,
  :generate_regnal_year_sessions,
  :generate_session_regnal_year_citations,
  :generate_session_numbers_for_regnal_year_citations
]