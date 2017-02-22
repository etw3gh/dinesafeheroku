class AddressesController < ApplicationController

  # retuns the municipalities in alpha order
  def mun
    render :json => Address.order(:mun).distinct.pluck(:mun)
  end 

  def munstreets
    mun = params[:mun]
    render :json => Address.where(:mun=>mun).order(:streetname).distinct.pluck(:streetname)
  end
  # returns all streets in the city in alpha order
  def streets
    render :json => Address.order(:streetname).distinct.pluck(:streetname)
  end

  # returns just the numbers in ascending order for a given street
  def numbers
    street = params[:street].downcase
    render :json => Address.where("streetname like '#{street}%'").order(:num).pluck(:num).sort_by(&:to_i)
  end
end