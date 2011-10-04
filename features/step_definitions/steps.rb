Given /^I am logged in$/ do
  @uid = 42
  @oauth = mock('oauth')
  @graph = mock('graph')
  setup_mock_graph
  @user = User.new(@graph, 42)
  Koala::Facebook::OAuth.should_receive(:new).any_number_of_times.and_return(@oauth)
  user_info = {'access_token' => '1234567890', 'uid' => 42}
  @oauth.should_receive(:get_user_info_from_cookie).any_number_of_times.and_return(user_info)
  Koala::Facebook::GraphAPI.should_receive(:new).any_number_of_times.with('1234567890').and_return(@graph)
  User.should_receive(:new).with(@graph, 42).any_number_of_times.and_return(@user)
end

When /^I visit the index$/ do
  visit(root_url)
end

When /^I click the (\w+) link$/ do |link|
  find_link(link).click
end

Then /^I should see the following friends:$/ do |friends|
  friends.hashes.each do |friend|
    page.has_content?(friend["name"])
  end
end