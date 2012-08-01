RedisSearchExample::Application.routes.draw do
  root :to => "projects#index"
  resources :projects do
    collection do
      get :search
    end
  end
end
