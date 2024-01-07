class PagesController < ApplicationController
  def home
    @conversion = Conversion.new
  end
end
