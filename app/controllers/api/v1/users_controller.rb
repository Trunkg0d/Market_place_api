class Api::V1::UsersController < ApplicationController
    def index
        @users = User.all
        render json: @users
    end

    def show
        @user = User.find(params[:id])
        options = {include: [:products]}
        render json: UserSerializer.new(@user, options).serializable_hash
    end

    def create
        @user = User.new(user_params)
        if @user.save
            render json: UserSerializer.new(@user).serializable_hash, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            render json: UserSerializer.new(@user).serializable_hash
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        head 204
    end

    private
    def user_params
        params.require(:user).permit(:email, :password)
    end

    def check_owner
        head :forbidden unless @user.id == current_user.id
    end
end
