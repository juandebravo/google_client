Rails.application.routes.draw do

  get "google_client/index"
  
  get "google_client/oauth2callback"

  get "google_client/show"

end
