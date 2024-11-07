module CapybaraHelpers
  module Session
    def sign_in_as(user)
      visit new_user_session_path
      expect(page).to have_text('Log in')

      fill_in('user[email]', with: user.email)
      fill_in('user[password]', with: 'qwerty123')
      click_button('Log in')

      expect(page).to have_text('Signed in successfully.')
    end
  end
end
