require 'spec_helper'

describe FacebookController do
  
  describe 'top_feed_commenters with GET' do
    before do
      setup_mock_graph_and_user
    end
    
    describe 'when logged into facebook' do
      before do
        login_to_facebook
        @top_feed_commenters = mock('top_feed_commenters')
        @friend_user = mock('friend_user')
        User.should_receive(:new).with(@graph, 43).and_return(@friend_user)
        @friend_user.should_receive(:top_feed_commenters).and_return(@top_feed_commenters)
        get :top_feed_commenters, :friend_id => 43
      end
      
      it { response.should be_success }
      it 'should assign top_feed_commenters' do
        assigns[:top_feed_commenters].should == @top_feed_commenters
      end
    end
  end
  
  describe 'friends with GET' do
    before do
      setup_mock_graph_and_user
      @friends = mock('friends')
      @limit_and_offset = 25
    end
    
    describe 'when logged into facebook' do
      before do
        login_to_facebook
        @user.should_receive(:friends).once.and_return(@friends)
        get :friends
      end
      
      it { response.should be_success }
      it 'should assign friends' do
        assigns[:friends].should == @friends
      end
    end
    
    describe 'with paging and all appropriate params' do
      before do
        login_to_facebook
        @user.should_receive(:friends).with({ :limit => @limit_and_offset, :offset => @limit_and_offset }).once.and_return(@friends)
        get :friends, { :limit => @limit_and_offset, :offset => @limit_and_offset }
      end
      
      it { response.should be_success }
      it 'should assign offset' do
        assigns[:offset].should == @limit_and_offset
      end
    end
  end
  
  describe 'index with GET' do
    before do
      setup_mock_graph_and_user
    end

    context 'when logged into facebook' do
      before do
        login_to_facebook
        @likes = mock('likes')
        @user.should_receive(:likes_by_category).and_return(@likes)
        get :index
      end

      it do
        response.should be_success
      end

      it 'should assign likes' do
        assigns[:likes_by_category].should == @likes
      end
    end

    context 'when not logged into facebook' do
      before do
        @oauth.should_receive(:get_user_info_from_cookie).and_return(nil)

        get :index
      end

      it 'should redirect to the login page' do
        response.should redirect_to(:action => :login)
      end
    end
  end

  describe 'login with GET' do
    before do
      get :login
    end

    it do
      response.should be_success
    end
  end
  
  def setup_mock_graph_and_user
    @user = User.new(mock('graph'), 42)
    @oauth = mock('oauth')
    @graph = mock('graph')
    Koala::Facebook::OAuth.should_receive(:new).and_return(@oauth)
  end
  
  def login_to_facebook
    user_info = {'access_token' => '1234567890', 'uid' => 42}
    @oauth.should_receive(:get_user_info_from_cookie).and_return(user_info)
    Koala::Facebook::GraphAPI.should_receive(:new).with('1234567890').and_return(@graph)
    User.should_receive(:new).with(@graph, 42).and_return(@user)
  end
end
