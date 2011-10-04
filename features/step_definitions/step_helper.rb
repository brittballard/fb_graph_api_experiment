def setup_mock_graph
  @single_top_commenter_id = "596914111"
  @multiple_top_commenter_id = "1300913662"
  @no_top_commenter_id = "7961179"
  
  @graph.should_receive(:get_connections).with(@uid, 'likes').any_number_of_times.and_return(likes)
  @graph.should_receive(:get_connections).with(@uid, 'friends').any_number_of_times.and_return(friends)

  @graph.should_receive(:get_connections).with(@single_top_commenter_id, "feed", { :limit => 500, :fields => "from" }).any_number_of_times.and_return(single_top_commenter_feed(@single_top_commenter_id))
  @graph.should_receive(:get_connections).with(@multiple_top_commenter_id, "feed", { :limit => 500, :fields => "from" }).any_number_of_times.and_return(multiple_top_commenters_feed(@multiple_top_commenter_id))
  @graph.should_receive(:get_connections).with(@no_top_commenter_id, "feed", { :limit => 500, :fields => "from" }).any_number_of_times.and_return(no_top_commenters_feed(@no_top_commenter_id))

  @graph.should_receive(:get_object).with(@single_top_commenter_id, { :fields => "name" }).any_number_of_times.and_return({ "name" => "Aaron Boswell" })
  @graph.should_receive(:get_object).with(@multiple_top_commenter_id, { :fields => "name" }).any_number_of_times.and_return({ "name" => "Amber Knight" })
  @graph.should_receive(:get_object).with(@no_top_commenter_id, { :fields => "name" }).any_number_of_times.and_return({ "name" => "Adrian Thomas" })
end

def no_top_commenters_feed(uid)
  single_top_commenter_feed(uid).select { |post| post['from']['id'] == uid }
end

def multiple_top_commenters_feed(uid)
  single_top_commenter_feed(uid) << {
                                  "id" => "1044302049_2218102325781", 
                                  "from"=> {
                                            "name"=>"Chris Sherwyn", 
                                            "id"=>"8321440"
                                            }, 
                                }
end

def single_top_commenter_feed(uid)
  [
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
                "id"=>"#{uid}"
              }, 
    }, 
    {
      "id"=>"1044302049_2216325561364", 
      "from"=>{
                "name"=>"Colin Rohan Simithraaratchy", 
                "id"=>"#{uid}"
              }, 
    }, 
    {
      "id"=>"1044302049_2216325561365", 
      "from"=>{
                "name"=>"Colin Rohan Simithraaratchy", 
                "id"=>"#{uid}"
              }, 
    }, 
    {
      "id"=>"1044302049_2138559657264", 
      "from"=>{
                "name"=>"Collin Williams", 
                "id"=>"1492711784"
              }
    },
    {
      "id"=>"1044302049_21385596572656", 
      "from"=>{
                "name"=>"Collin Williams", 
                "id"=>"1492711784"
              }
    }
  ]
end

def likes
  [
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
end

def friends
  [
    {
      "name"=>"Troy Thomas", 
      "id"=>"1462447084"
    }, 
    {
      "name"=>"Van Pham", 
      "id"=>"572753773"
    }, 
    {
      "name"=>"Vandita Khire", 
      "id"=>"100001031083123"
    }, 
    {
      "name"=>"Adam Solomons", 
      "id"=>"1011976173"
    }, 
    {
      "name"=>"Adam Strickland", 
      "id"=>"715402457"
    }, 
    {
      "name"=>"Adam Winburne", 
      "id"=>"100000988090210"
    }, 
    {
      "name"=>"Adrian Thomas", 
      "id"=>"7961179"
    }, 
    {
      "name"=>"Akhil Patel", 
      "id"=>"8319827"
    }, 
    {
      "name"=>"Alan Volk", 
      "id"=>"9631999"
    }, 
    {
      "name"=>"Aldana Marie", 
      "id"=>"597847577"
    }, 
    {
      "name"=>"Aldrich Varilla", 
      "id"=>"8335841"
    }, 
    {
      "name"=>"Allison Porter Sealy", 
      "id"=>"1575316799"
    }, 
    {
      "name"=>"Amal Cole", 
      "id"=>"100000695416222"
    }, 
    {
      "name"=>"Amanda Aguirre Jennings", 
      "id"=>"540581136"
    }, 
    {
      "name"=>"Amanda Hodge", 
      "id"=>"1438418427"
    }, 
    {
      "name"=>"Amanda L. Pridemore", 
      "id"=>"1533606237"
    }, 
    {
      "name"=>"Amber Knight", 
      "id"=>"1300913662"
    }, 
    {
      "name"=>"Amber Lemley Hart", 
      "id"=>"1089387139"
    }, 
    {
      "name"=>"Amy Bose Siler", 
      "id"=>"9207623"
    }, 
    {
      "name"=>"Andrea Whalen", 
      "id"=>"513659892"
    }, 
    {
      "name"=>"Andrew Bose", 
      "id"=>"8347782"
    }, 
    {
      "name"=>"Andrew Cobb", 
      "id"=>"29600066"
    }, 
    {
      "name"=>"Andrew Crowley", 
      "id"=>"725622672"
    }, 
    {
      "name"=>"Andy Frazier", 
      "id"=>"653314701"
    }, 
    {
      "name"=>"Andy Wheaton", 
      "id"=>"1448063704"
    }, 
    {
      "name"=>"Angie Pete Yowell", 
      "id"=>"514511768"
    }, 
    {
      "name"=>"Anna Wollscheid", 
      "id"=>"5615904"
    }, 
    {
      "name"=>"Anne Swanson", 
      "id"=>"764804693"
    }, 
    {
      "name"=>"Annie Elizabeth Palmer", 
      "id"=>"585600991"
    }, 
    {
      "name"=>"Annie Murray", 
      "id"=>"708532505"
    }, 
    {
      "name"=>"Anthony Renda", 
      "id"=>"515970289"
    }, 
    {
      "name"=>"Anuj Kamthan", 
      "id"=>"750239297"
    }, 
    {
      "name"=>"Ashley Martel Malina", 
      "id"=>"1634270724"
    }, 
    {
      "name"=>"Ashley Shugart", 
      "id"=>"25305606"
    }, 
    {
      "name"=>"Audrey Sheppard Bose", 
      "id"=>"712026954"
    }, 
    {
      "name"=>"Austin Gray", 
      "id"=>"655996240"
    }, 
    {
      "name"=>"Bankim Tejani", 
      "id"=>"776465600"
    }, 
    {
      "name"=>"Aaron Boswell", 
      "id"=>"596914111"
    }, 
    {
      "name"=>"Aaron Holladay", 
      "id"=>"544717876"
    }, 
    {
      "name"=>"Abhijeet Yadwadkar", 
      "id"=>"1056808436"
    }, 
    {
      "name"=>"Adam Desmond", 
      "id"=>"1384943422"
    }, 
    {
      "name"=>"Adam Maloney", 
      "id"=>"8313187"
    }, 

    {
      "name"=>"Barbara Stoerner", 
      "id"=>"37500192"
    }, 
    {
      "name"=>"Trey Denson", 
      "id"=>"23417220"
    }, 
    {
      "name"=>"Trey Milton", 
      "id"=>"708150451"
    }, 
    {
      "name"=>"Veronica Arriaga", 
      "id"=>"510157976"
    }, 
    {
      "name"=>"Victor Salazar", 
      "id"=>"1375404327"
    }, 
    {
      "name"=>"Visar Gashi", 
      "id"=>"1070285979"
    }, 
    {
      "name"=>"Vishal Bardoloi", 
      "id"=>"709429972"
    }, 
    {
      "name"=>"Vivian V. Acosta", 
      "id"=>"504654175"
    }, 
    {
      "name"=>"Wayne Simpkins", 
      "id"=>"519623665"
    }, 
    {
      "name"=>"Whitney Bright", 
      "id"=>"20600532"
    }, 
    {
      "name"=>"Will Bekheet", 
      "id"=>"1348560617"
    }, 
    {
      "name"=>"Will K", 
      "id"=>"505211851"
    }
  ]
end