class Api::V1::ProductsController < ApplicationController
    before_action :check_login, only: [:create]
    before_action :check_owner, only: [:update, :destroy]
    include Paginable
    
    def show
        @product = Product.find(params[:id])
        options = { include: [:user] }
        render json: ProductSerializer.new(@product, options).serializable_hash
    end

    def index
        @products = Product.page(params[:page]).per(params[:per_page]).search(params)
        options = {
            links: {
                first: api_v1_products_path(page: 1),
                last: api_v1_products_path(page: @products.total_pages),
                prev: api_v1_products_path(page: @products.prev_page),
                next: api_v1_products_path(page: @products.next_page),
            }              
        }
        render json: ProductSerializer.new(@products, options).serializable_hash
    end

    def create
        @product = Product.new(product_params)
        if @product.save
            render json: ProductSerializer.new(@product).serializable_hash, status: :created
        else
            render json: {errors: @product.errors}, status: :unprocessable_entity
        end 
    end

    def update
        @product = Product.find(params[:id])
        if @product.update(product_params)
            render json: ProductSerializer.new(@product).serializable_hash
            
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
