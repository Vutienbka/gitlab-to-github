class UserController < ApplicationController
    before_action :authenticate_user!, only: [:index, :destroy]
    def index
        # redirect_to admins_root_path
    end
    def destroy
        # redirect_to signout_path
    end
end
