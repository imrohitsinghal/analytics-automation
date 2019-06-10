When(/^I open the thoughtworks website$/) do
    visit "https://www.thoughtworks.com"
    # print page
    expect(page).to have_selector '.header__logo', wait: 10
    # expect(page).to have_text('ThoughtWorks')
end