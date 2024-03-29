class FacebookController < ApplicationController

  before_filter :facebook_auth
  before_filter :require_login, :except => :login

  helper_method :logged_in?, :current_user
  
  def index
    @likes_by_category = current_user.likes_by_category
  end

  def login
  end

  def friends
    @friends = current_user.friends()
    @offset = params[:offset].to_i
  end

  def feed_commenters
    @friend_user = User.new(@graph, params[:friend_id])
    @feed_commenters = @friend_user.feed_commenters_with_comment_count
  end

  protected

    def logged_in?
      !!@user
    end

    def current_user
      @user
    end

    def require_login
      unless logged_in?
        redirect_to :action => :login
      end
    end

    def facebook_auth
      @oauth = Koala::Facebook::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_SECRET_KEY)
      if fb_user_info = @oauth.get_user_info_from_cookie(request.cookies)
        @graph = Koala::Facebook::GraphAPI.new(fb_user_info['access_token'])
        @user = User.new(@graph, fb_user_info['uid'])
      end
    end
end
