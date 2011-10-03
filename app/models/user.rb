class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def friends
    @friends ||= graph.get_connections(uid, 'friends')
  end

  def feed
    @feed ||= graph.get_connections(uid, 'feed', :limit => 100)
  end

  def likes
    @likes ||= graph.get_connections(uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end
  
  def top_feed_commenter
    @top_feed_commenter ||= feed.select { |post| post['from']['id'] != @uid.to_s }
                              .group_by{ |post| post['from'] }
                                .values
                                  .sort{ |posts1,posts2| posts2.count <=> posts1.count }
                                    .first
                                      .first['from']
  end
end
