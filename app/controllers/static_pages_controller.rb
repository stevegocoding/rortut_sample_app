class StaticPagesController < ApplicationController
  def home
    puts "StaticPagesController#home"
  end

  def help
    puts "StaticPagesController#help"
  end

  def about
    puts "StaticPagesController#about"
  end
  
  def contact
    puts "StaticPagesController#contact"
  end
end
