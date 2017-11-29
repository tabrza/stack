feature "Sign in" do
  scenario "User can sign in" do
    sign_up
    sign_in('example@example.com', 'password123')
    expect(page).to have_content('Oleg Gru')
  end
end
