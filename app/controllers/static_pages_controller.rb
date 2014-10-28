class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if signed_in?
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
