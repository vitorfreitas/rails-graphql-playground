Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post "/graphql", to: "graphql#execute"

  resources :users, param: :_username, constraints: { _username: /[^\/]+/ }
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
