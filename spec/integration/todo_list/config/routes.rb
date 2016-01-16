BijouApp.routes.draw do
  root "pages#index" # list all todo items
  get "agenda/new", to: "agendas#new" # Return an html form for creating a new todo item
  post "agenda/new", to: "agendas#create" # Save a todo item
  get "agenda/:id/edit", to: "agendas#edit" # Return an html form for editing a todo item
  post "agenda/:id", to: "agendas#update" # Update a single todo item
  get "agenda/:id/delete", to: "agendas#destroy"
  post "agenda/:id/delete", to: "agendas#destroy" # Delete a single todo item
end
