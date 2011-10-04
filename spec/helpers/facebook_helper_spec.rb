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
      show_next_friend_page_icon(25, 200).should be_true
    end
    
    it 'should return true when friend_count is not equal to limit' do
      show_next_friend_page_icon(75, 100).should be_false
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
  
  describe '#get_friends_for_page' do
    it 'should return the correct subset of an array based on the offset provided' do
      test_array = (1..100).to_a
      get_friends_for_page(test_array, 20).should == (21..45).to_a
    end
  end
  
  describe "#is_or_are_top_commenters" do
    it 'should return is when there is one top commenter' do
      is_or_are_top_commenters(1).should == " is"
    end
    
    it 'should return are when there is one top commenter' do
      is_or_are_top_commenters(2).should == "s are"
    end
  end
  
  describe '#get_offset_for_letter' do
    it 'should return the correct offset to ensure that a name with the letter selected appears on the screen' do
      test_array = ('Aa'..'Za').to_a.map{ |name| {"name" => name} }
      get_offset_for_letter(test_array, 'C', 0).should == 50
    end
    
    it 'should return the previous offset if no name is found that starts with the letter being tested for' do
      test_array = ('A'..'D').to_a.map{ |name| {"name" => name} }
      get_offset_for_letter(test_array, 'F', 50).should == 50
    end
  end
end