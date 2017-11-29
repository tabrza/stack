feature "Registration/sign_up" do
  scenario "Fill in the form and see welcome massage" do
    sign_up
    expect { sign_up }.to change(User, :count).by(1)
    expect(User.first.email).to eq('example@example.com')
    expect(page).to have_content('Oleg Gru')
  end
end

feature "Registration/sign_up with mismatch passwords" do
  scenario "Fill in the form and see sign up form again" do
    sign_up_mismatch
    expect(page).to have_content('Sign up')
  end
end

feature "Submit peep" do
  scenario "Fill in the form to send the peep and display it" do
    sign_up
    post_a_peep
    expect { click_button 'Post'}.to change(Peep, :count).by(1)
    expect(page).to have_content('Hello World')
  end
end
