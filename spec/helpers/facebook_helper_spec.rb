require 'spec_helper'

describe FacebookHelper do
  describe '#get_friend_offset_forward' do
    it 'should return #{FRIENDS_PER_PAGE} when no params are provided' do
      get_friend_offset_forward.should == FRIENDS_PER_PAGE
    end
    
    it 'should return offset param plus #{FRIENDS_PER_PAGE}' do
      get_friend_offset_forward(10).should == FRIENDS_PER_PAGE + 10
    end
  end
  
  describe '#get_friend_offset_backwards' do
    it 'should return 0 when no params are provided' do
      get_friend_offset_backwards.should == 0
    end
    
    it 'should return offset param minus #{FRIENDS_PER_PAGE} when offset is larger than #{FRIENDS_PER_PAGE}' do
      get_friend_offset_backwards(35).should == 35 - FRIENDS_PER_PAGE
    end
  end
  
  describe '#get_friend_limit' do
    it 'should return #{FRIENDS_PER_PAGE}' do
      get_friend_limit.should == FRIENDS_PER_PAGE
    end
  end
  
  describe '#show_next_friend_page_icon' do
    it 'should return true when friend_count is equal to limit' do
      show_next_friend_page_icon(FRIENDS_PER_PAGE).should be_true
    end
    
    it 'should return true when friend_count is not equal to limit' do
      show_next_friend_page_icon(10).should be_false
    end
  end
  
  describe '#show_last_friend_page_icon' do
    it 'should return true when offset is not 0' do
      show_last_friend_page_icon(1).should be_true
    end
    
    it 'should return true when offset is 0' do
      show_last_friend_page_icon(0).should be_false
    end
  end
end