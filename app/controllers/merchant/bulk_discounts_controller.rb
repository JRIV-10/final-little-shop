class Merchant::BulkDiscountsController < ApplicationController
  def index 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end 

  def new 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.new(bulk_discount_params)
    if bulk_discount.save 
      redirect_to merchant_bulk_discounts_path(@merchant)
      flash[:notice] = "Succesfully Created a New Discount"
    else 
      require 'pry'; binding.pry
      redirect_to new_merchant_bulk_discount_path(@merchant)
      flash[:alert] = "Please fill in ALL required fields"
    end
  end

  def edit 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(bulk_discount_params)
      flash[:notice] = "Congratulations! You've edited the discount successfully!"

      redirect_to merchant_bulk_discount_path(params[:merchant_id], params[:id])
    else
      flash.now[:error] = "Couldn't fully update the Discount, please make sure ALL fields are filled out properly"

      render :edit
    end 
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private 

  def bulk_discount_params
    params.require(:bulk_discount).permit(:discount, :quantity, :merchant_id)
  end
end