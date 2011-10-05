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
      friend1["name"] <=> friend2["name"]
    end
  end

  def feed
    @feed ||= graph.get_connections(uid, 'feed', :limit => 500, :fields => 'comments')
  end

  def feed_comments
    @feed_with_zero_comment_posts_filtered ||= feed.map do |post| 
      post["comments"]["data"] unless post["comments"]["count"] == 0
    end.flatten.compact
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
  
  def feed_commenters_with_comment_count
    @top_feed_commenters ||= feed_comments.group_by { |comment| comment["from"]["id"] }
                              .map{ |from,comments| comments.first["from"]["comment_count"] = comments.count; comments.first["from"] }
  end
end
