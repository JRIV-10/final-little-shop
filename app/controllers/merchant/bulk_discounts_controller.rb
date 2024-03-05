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
    @merchant.bulk_discounts.new(bulk_discount_params)
    if @merchant.save 
      redirect_to merchant_bulk_discounts_path(@merchant)
      flash[:notice] = "Succesfully Created a New Discount"
    else 
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
      redirect_to merchant_bulk_discount_path(params[:merchant_id], params[:id])

      flash[:notice] = "Congratulations! You've edited the discount successfully!"
    else
      redirect_to edit_merchant_bulk_discount_path(params[:merchant_id], params[:id])

      flash[:alert] = "Couldn't fully update the Discount, please make sure ALL fields are filled out properly"
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