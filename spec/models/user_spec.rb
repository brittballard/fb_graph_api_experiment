require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
  end

  describe 'retriving friends' do
    before do
      @friends = [
        {
          "name"=>"Kim Nguyen", 
          "id"=>"700800"
        }, 
        {
          "name"=>"Fred Bliss", 
          "id"=>"1906778"
        }, 
        {
          "name"=>"Garrett Fox", 
          "id"=>"3007587"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'friends', {}).and_return(@friends)
    end
    
    describe '#friends' do
      it 'should retrieve friends via the graph api' do
        @user.friends.should == @friends
      end
    end
  end

  describe 'retriving feed' do
    before do
      @feed = [
        {
          "id" => "1044302049_2218102325781", 
          "from"=> {
                    "name"=>"Chris Sherwyn", 
                    "id"=>"8321440"
                    }, 
        }, 
        {
          "id"=>"1044302049_2216325561363", 
          "from"=>{
                    "name"=>"Colin Rohan Simithraaratchy", 
                    "id"=>"#{@uid}"
                  }, 
        }, 
        {
          "id"=>"1044302049_2138559657264", 
          "from"=>{
                    "name"=>"Collin Williams", 
                    "id"=>"1492711784"
                  }
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'feed', :limit => 500, :fields => 'from').once.and_return(@feed)
    end
    
    describe '#feed' do
      it 'should retrieve the feed via the graph api' do
        @user.feed.should == @feed
      end
      
      it 'should memoize the result after the first call' do
        feed1 = @user.feed
        feed2 = @user.feed
        feed2.should equal(feed1)
      end
    end
    
    describe '#feed_with_self_posts_filtered' do
      it 'should retreive the feed via the graph api and filter out all posts by the instantiated user' do
        @user.feed_with_self_posts_filtered.length.should == 2
        @user.feed_with_self_posts_filtered[0].should == @feed[0]
        @user.feed_with_self_posts_filtered[1].should == @feed[2]
      end
      
      it 'should return an empty array when only self posts are returned' do
        @feed.clear
        @feed << {
                    "id"=>"1044302049_2216325561363", 
                    "from"=>{
                              "name"=>"Colin Rohan Simithraaratchy", 
                              "id"=>"#{@uid}"
                            }, 
                  }
        @user.feed_with_self_posts_filtered.should == []
      end
    end
    
    describe '#top_feed_commenters' do
      before do
        @feed << {
                    "id"=>"1044302049_2138559657265", 
                    "from"=>{
                              "name"=>"Collin Williams", 
                              "id"=>"1492711784"
                            }
                  }
      end
      
      it 'should retrieve the feed via the graph api and determine which user is the most consistent poster other than the user themselves' do
        @user.top_feed_commenters.should == [{
                                              "name" => "Collin Williams",
                                              "id" => "1492711784"
                                            }]
      end
      
      it 'should return multiple friends when there is a comment count tie' do
        @feed << {
                    "id" => "1044302049_2218102325781", 
                    "from"=> {
                              "name"=>"Chris Sherwyn", 
                              "id"=>"8321440"
                              }, 
                  }
        
        @user.top_feed_commenters.count.should == 2
        @user.top_feed_commenters.should include({
                                                    "name" => "Collin Williams",
                                                    "id" => "1492711784"
                                                  })
                                            
        @user.top_feed_commenters.should include({
                                                    "name" => "Chris Sherwyn",
                                                    "id" => "8321440"
                                                  })
      end
      
      it 'should return an empty array when only self posts, or no posts, are returned in the feed' do
        @feed.clear
        @user.top_feed_commenters.should == []
      end
    end
  end

  describe 'retrieving likes' do
    before do
      @likes = [
        {
          "name" => "The Office",
          "category" => "Tv show",
          "id" => "6092929747",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Flight of the Conchords",
          "category" => "Tv show",
          "id" => "7585969235",
          "created_time" => "2010-08-22T06:33:56+0000"
        },
        {
          "name" => "Wildfire Interactive, Inc.",
          "category" => "Product/service",
          "id" => "36245452776",
          "created_time" => "2010-06-03T18:35:54+0000"
        },
        {
          "name" => "Facebook Platform",
          "category" => "Product/service",
          "id" => "19292868552",
          "created_time" => "2010-05-02T14:07:10+0000"
        },
        {
          "name" => "Twitter",
          "category" => "Product/service",
          "id" => "20865246992",
          "created_time" => "2010-05-02T14:07:10+0000"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'likes').once.and_return(@likes)
    end

    describe '#likes' do
      it 'should retrieve the likes via the graph api' do
        @user.likes.should == @likes
      end

      it 'should memoize the result after the first call' do
        likes1 = @user.likes
        likes2 = @user.likes
        likes2.should equal(likes1)
      end
    end

    describe '#likes_by_category' do
      it 'should group by category and sort categories and names' do
        @user.likes_by_category.should == [
          ["Product/service", [
            {
              "name" => "Facebook Platform",
              "category" => "Product/service",
              "id" => "19292868552",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Twitter",
              "category" => "Product/service",
              "id" => "20865246992",
              "created_time" => "2010-05-02T14:07:10+0000"
            },
            {
              "name" => "Wildfire Interactive, Inc.",
              "category" => "Product/service",
              "id" => "36245452776",
              "created_time" => "2010-06-03T18:35:54+0000"
            }
          ]],
          ["Tv show", [
            {
              "name" => "Flight of the Conchords",
              "category" => "Tv show",
              "id" => "7585969235",
              "created_time" => "2010-08-22T06:33:56+0000"
            },
            {
              "name" => "The Office",
              "category" => "Tv show",
              "id" => "6092929747",
              "created_time" => "2010-05-02T14:07:10+0000"
            }
          ]]
        ]
      end
    end
  end
end
