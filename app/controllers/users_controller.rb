class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :destroy]
    def index
        # redirect_to admins_root_path
    end
    def destroy
        # redirect_to signout_path
    end

    def choose_provider
    end 

    def email_register_item
    end 

    def email_register_supplier
    end 

    def invite_form
    end 

    def register_item
    end 

    def search_provider
    end 
end
