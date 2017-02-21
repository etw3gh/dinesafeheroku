class AddressesController < ApplicationController
  def mun
    render :json => Address.select(:mun).distinct.pluck(:mun)

  end 
end