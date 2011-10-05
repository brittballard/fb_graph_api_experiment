require 'spec_helper'

describe User do
  before do
    @graph = mock('graph api')
    @uid = 42
    @user = User.new(@graph, @uid)
  end

  describe '#name' do
    before do
      @me = {
              "name" => "Britt Ballard",
              "id" => @uid
            }
      @graph.should_receive(:get_object).with(@uid, :fields => 'name').once.and_return(@me)
    end
    
    it 'should return the users name' do
      @user.name.should == "Britt Ballard"
    end
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
          "name"=>"Garrett A Fox", 
          "id"=>"3007587"
        }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'friends').and_return(@friends)
    end
    
    describe '#friends' do
      it 'should retrieve friends via the graph api and alphabatize them' do
        @user.friends.should == [
                                  {
                                    "name"=>"Fred Bliss", 
                                    "id"=>"1906778"
                                  }, 
                                  {
                                    "name"=>"Garrett A Fox", 
                                    "id"=>"3007587"
                                  },
                                  {
                                    "name"=>"Kim Nguyen", 
                                    "id"=>"700800"
                                  }
                                ]
      end
    end
  end

  describe 'retriving feed' do
    before do
      @feed = [
        {
          "comments"=> { "count"=>0 }, 
          "id"=>"670043931_141884102577279", 
          "created_time"=>"2011-10-05T04:27:36+0000"
        }, 
        {
          "comments"=>
            {
              "data"=>[
                        {
                          "id"=>"670043931_10150316437798932_4919523", 
                          "from"=> { "name"=>"Molly Tracy", "id"=>"100000206650507" }, 
                          "message"=>"wear glitter!", 
                          "created_time"=>"2011-10-03T01:14:40+0000", 
                          "likes"=>2
                        }, 
                        {
                          "id"=>"670043931_10150316437798932_4920371", 
                          "from"=> { "name"=>"Justin Shannon", "id"=>"812139048" }, 
                          "message"=>"Wear glitter!", 
                          "created_time"=>"2011-10-03T04:03:14+0000", 
                          "likes"=>1
                        }, 
                      ], 
              "count" => 2
            },
            "id"=>"670043931_141884102577280", 
            "created_time"=>"2011-10-05T04:27:36+0000"
          },
          {
            "comments"=>
              {
                "data"=>[
                          {
                            "id"=>"670043931_10150316437798932_4919523", 
                            "from"=>{ "name"=>"Molly Tracy 2", "id"=>"100000206650507" }, 
                            "message"=>"wear glitter!", 
                            "created_time"=>"2011-10-03T01:14:40+0000", 
                            "likes"=>2
                          }
                ], 
                "count" => 1
            },
            "id"=>"670043931_141884102577280", 
            "created_time"=>"2011-10-05T04:27:36+0000"
          }
      ]
      @graph.should_receive(:get_connections).with(@uid, 'feed', :limit => 500, :fields => 'comments').once.and_return(@feed)
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
    
    describe "#feed_comments" do
      it 'should return an array of the comment hashes only' do
        @user.feed_comments.should == [
            {
              "id" => "670043931_10150316437798932_4919523", 
              "from" => { "name" => "Molly Tracy", "id"=>"100000206650507" }, 
              "message"=>"wear glitter!", 
              "created_time"=>"2011-10-03T01:14:40+0000", 
              "likes"=>2
            }, 
            {
              "id"=>"670043931_10150316437798932_4920371", 
              "from"=> { "name"=>"Justin Shannon", "id"=>"812139048" }, 
              "message"=>"Wear glitter!", 
              "created_time"=>"2011-10-03T04:03:14+0000", 
              "likes"=>1
            },
            {
              "id"=>"670043931_10150316437798932_4919523", 
              "from"=>{ "id"=>"100000206650507", "name"=>"Molly Tracy 2" }, 
              "message"=>"wear glitter!", 
              "created_time"=>"2011-10-03T01:14:40+0000", 
              "likes"=>2
            }
          ]
      end
    end
    
    describe '#feed_commenters_with_comment_count' do
      it 'should return an array of commenters including the number of comments they have posted' do
        @user.feed_commenters_with_comment_count.count.should == 2
        @user.feed_commenters_with_comment_count.should include({ "name" => "Molly Tracy", "id" => "100000206650507", "comment_count" => 2 })
        @user.feed_commenters_with_comment_count.should include({ "name" => "Justin Shannon", "id" => "812139048", "comment_count" => 1 })
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
