Rails.application.routes.draw do
  
  root 'loan_details#index'
  
  # Routes for the Loan detail resource:

  # CREATE
  get("/loan_details/new", { :controller => "loan_details", :action => "new_form" })
  post("/create_loan_detail", { :controller => "loan_details", :action => "create_row" })

  # READ
  get("/loan_details", { :controller => "loan_details", :action => "index" })
  get("/loan_details/:id_to_display", { :controller => "loan_details", :action => "show" })

  # UPDATE
  get("/loan_details/:prefill_with_id/edit", { :controller => "loan_details", :action => "edit_form" })
  post("/update_loan_detail/:id_to_modify", { :controller => "loan_details", :action => "update_row" })

  # DELETE
  get("/delete_loan_detail/:id_to_remove", { :controller => "loan_details", :action => "destroy_row" })

  #------------------------------

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
