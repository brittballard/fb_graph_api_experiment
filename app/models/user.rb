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
  
  def top_commenter
    feed
    {"name"=>"Collin Williams", "id"=>"1492711784"}
  end
end
