class Merchant::InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    invoice_item.update(update_status_params)

    redirect_to merchant_invoice_path(params[:merchant_id], invoice_item.invoice_id)
  end

  private

  def update_status_params
    params.permit(:status)
  end
end
