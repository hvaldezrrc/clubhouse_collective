class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address

  def edit
    @provinces = Province.all
  end

  def update
    if @address.update(address_params)
      redirect_to dashboard_path, notice: "Address was successfully updated."
    else
      @provinces = Province.all
      render :edit
    end
  end

  private

  def set_address
    @address = current_user.address || current_user.build_address
  end

  def address_params
    params.require(:address).permit(:street, :city, :zip, :province_id)
  end
end
