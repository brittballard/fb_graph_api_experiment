module FacebookHelper
  
  FRIENDS_PER_PAGE = 25
  
  def facebook_login_button(size='large')
    content_tag("fb:login-button", nil , {
      :perms => 'user_likes, friends_likes, read_stream',
      :id => "fb_login",
      :autologoutlink => 'true',
      :size => size,
      :onlogin => 'location = "/"'})
  end
  
  def get_friend_offset
    get_friend_offset_forward
  end
  
  def get_friend_offset_forward(offset=0)
    offset + FRIENDS_PER_PAGE
  end
  
  def get_friend_offset_backwards(offset=0)
    offset - FRIENDS_PER_PAGE < 0 ? 0 : offset - FRIENDS_PER_PAGE
  end
  
  def get_friend_limit
    FRIENDS_PER_PAGE
  end
  
  def show_next_friend_page_icon(friend_count)
    FRIENDS_PER_PAGE == friend_count
  end
  
  def show_last_friend_page_icon(offset)
    offset != 0
  end
end
