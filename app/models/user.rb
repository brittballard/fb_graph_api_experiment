class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def name
    @name ||= graph.get_object(uid, :fields => 'name')['name']
  end

  def friends()
    @friends ||= graph.get_connections(uid, 'friends').sort do |friend1, friend2|
                                                              friend1["name"].scan(/\w+/).first <=> friend2["name"].scan(/\w+/).first
                                                            end
  end

  def feed
    @feed ||= graph.get_connections(uid, 'feed', :limit => 500, :fields => 'from')
  end

  def feed_with_self_posts_filtered
    @feed_with_self_posts_filtered ||= feed.select { |post| post['from']['id'] != @uid.to_s }
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
  
  def top_feed_commenters
    max_number_of_comments = 0
    @top_feed_commenters ||= feed_with_self_posts_filtered
                              .inject({}) do |hash, post| 
                                hash.has_key?(post['from']) ? hash[post['from']] = hash[post['from']] + 1 : hash[post['from']] = 1
                                max_number_of_comments = hash[post['from']] unless hash[post['from']] <= max_number_of_comments
                                hash
                              end.select{ |key, value| value == max_number_of_comments }
                                  .map{ |commenter_information| commenter_information[0] }
  end
end
