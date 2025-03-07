# == Schema Information
#
# Table name: session_regnal_years
#
#  id             :integer          not null, primary key
#  regnal_year_id :integer          not null
#  session_id     :integer          not null
#
# Foreign Keys
#
#  fk_regnal_year  (regnal_year_id => regnal_years.id)
#  fk_session      (session_id => sessions.id)
#
class SessionRegnalYear < ApplicationRecord
  
  belongs_to :session
  belongs_to :regnal_year
end
