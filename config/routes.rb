Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  mount LibraryDesign::Engine => "/library_design"

  # Defines the root path route ("/")
  root "home#index"
  
  get 'regnal-years' => 'home#index', as: :home
  
  get 'regnal-years/calculate' => 'calculate#index', as: :calculate
  
  get 'regnal-years/parliament-periods' => 'parliament_period#index', as: :parliament_period_list
  get 'regnal-years/parliament-periods/:parliament_period' => 'parliament_period#show', as: :parliament_period_show
  
  get 'regnal-years/sessions' => 'session#index', as: :session_list
  get 'regnal-years/sessions/:session' => 'session#show', as: :session_show
  
  get 'regnal-years/regnal-years' => 'regnal_year#index', as: :regnal_year_list
  get 'regnal-years/regnal-years/:regnal_year' => 'regnal_year#show', as: :regnal_year_show
  
  get 'regnal-years/reigns' => 'reign#index', as: :reign_list
  get 'regnal-years/reigns/:reign' => 'reign#show', as: :reign_show
  
  get 'regnal-years/monarchs' => 'monarch#index', as: :monarch_list
  get 'regnal-years/monarchs/:monarch' => 'monarch#show', as: :monarch_show
  
  get 'regnal-years/kingdoms' => 'kingdom#index', as: :kingdom_list
  get 'regnal-years/kingdoms/:kingdom' => 'kingdom#show', as: :kingdom_show
  
  get 'regnal-years/meta' => 'meta#index', as: :meta_list
  get 'regnal-years/meta/schema' => 'meta#schema', as: :meta_schema
  get 'regnal-years/meta/cookies' => 'meta#cookies', as: :meta_cookies
end
