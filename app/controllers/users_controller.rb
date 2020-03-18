class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:index, :destroy]
    def index
        # redirect_to admins_root_path
    end
    def destroy
        # redirect_to signout_path
    end
    def sample_input
        
    end
    def batch_items_selector
        
    end
end
