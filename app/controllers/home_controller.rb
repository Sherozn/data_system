class HomeController < ApplicationController
  before_action :check_login, only:[:index]
  def index
  	@posts = Post.where(status:0).order(as_type: :desc,updated_at: :desc)
  end
end
