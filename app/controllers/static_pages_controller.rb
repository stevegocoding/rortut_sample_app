class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build if signed_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
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
