Given /^I am logged in$/ do
  @uid = 42
  @oauth = mock('oauth')
  @graph = mock('graph')
  setup_mock_graph
  @user = User.new(@graph, @uid)
  Koala::Facebook::OAuth.should_receive(:new).any_number_of_times.and_return(@oauth)
  user_info = {'access_token' => '1234567890', 'uid' => @uid}
  @oauth.should_receive(:get_user_info_from_cookie).any_number_of_times.and_return(user_info)
  Koala::Facebook::GraphAPI.should_receive(:new).any_number_of_times.with('1234567890').and_return(@graph)
end

When /^I visit the index$/ do
  visit(root_url)
end

When /^I click the (.+) link$/ do |link|
  find_link(link).click
end

Then /^I should see the following friends:$/ do |friends|
  friends.hashes.each do |friend|
    page.has_content?(friend["name"]).should be_true
  end
end

Then /^I should not see the following friends:$/ do |friends|
  friends.hashes.each do |friend|
    page.has_content?(friend["name"]).should be_false
  end
end

Then /^I should see the following text (.+)$/ do |text|
  page.has_content?(text).should be_true
end