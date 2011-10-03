Given /^I am logged in$/ do
  
end

When /^I visit the index$/ do
  cookies['access_token'] = 'Britton'
  visit('/')
end

Then /^I should see a Friends link$/ do
  pending # express the regexp above with the code you wish you had
end