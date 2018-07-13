class HomeController < ApplicationController
  def index
    flash['success'] = "Hello Mr, How are you ?"
  end
end
