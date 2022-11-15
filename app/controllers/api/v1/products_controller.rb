class Api::V1::ProductsController < ApplicationController
    before_action :check_login, only: [:create]
    before_action :check_owner, only: [:update, :destroy]
    def show
        render json: Product.find(params[:id])
    end

    def index
        render json: Product.all
    end

    def create
        @product = Product.new(product_params)
        if @product.save
            render json: @product, status: :created
        else
            render json: {errors: @product.errors}, status: :unprocessable_entity
        end 
    end

    def update
        @product = Product.find(params[:id])
        if @product.update(product_params)
            render json: @product, status: :ok
        else
            render json: @product.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @product = Product.find(params[:id])
        @product.destroy
        head 204
    end

    private
    def product_params
        params.require(:product).permit(:title, :published, :price, :user_id)
    end

    def check_owner
        head :forbidden unless @product.user_id == current_user.id
    end
end
