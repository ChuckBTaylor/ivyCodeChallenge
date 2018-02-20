Rails.application.routes.draw do
  resources :celebs
  post 'celeb_birthdays', to: 'celebs#get_birthdays'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
