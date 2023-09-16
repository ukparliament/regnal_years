Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  get '/' => 'home#index'
  
  get 'regnal-years' => 'home#index', as: :home
  
  get 'regnal-years/monarchs' => 'monarch#index', as: :monarch_list
  get 'regnal-years/monarchs/:monarch' => 'monarch#show', as: :monarch_show
  
  get 'regnal-years/reigns' => 'reign#index', as: :reign_list
  get 'regnal-years/reigns/:reign' => 'reign#show', as: :reign_show
  
  get 'regnal-years/regnal-years' => 'regnal_year#index', as: :regnal_year_list
  get 'regnal-years/regnal-years/:regnal_year' => 'regnal_year#show', as: :regnal_year_show
  
  get 'regnal-years/parliament-periods' => 'parliament_period#index', as: :parliament_period_list
  get 'regnal-years/parliament-periods/:parliament_period' => 'parliament_period#show', as: :parliament_period_show
  
  get 'regnal-years/sessions' => 'session#index', as: :session_list
  get 'regnal-years/sessions/:session' => 'session#show', as: :session_show
end
