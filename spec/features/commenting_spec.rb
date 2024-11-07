RSpec.describe 'Commenting projects', type: :feature, js: true do
  include CapybaraHelpers::Session

  let(:project) { Fabricate :project }
  let(:user) { Fabricate :user }

  before { sign_in_as user }

  describe 'Create a new comment' do
    it 'creates a new comment and adds it under the project' do
      visit project_path(project)

      new_comment_body = 'Lorem ipsum! Whatever it means.'

      within('.new_comment_wrapper') do
        fill_in('comment[body]', with: new_comment_body)
        click_button('Create Comment')
      end

      within('.comments') do
        expect(page).to have_text("#{user.email} says:")
        expect(page).to have_text(new_comment_body)
      end
    end
  end

  describe 'Edit comment' do
    let(:comment) { Fabricate :comment, project: project }
    let!(:old_comment_body) { comment.body }

    it 'updates the comment and adds changes history link' do
      visit project_path(project)

      within("#comment_#{comment.id}") do
        expect(page).to have_text("#{comment.user.email} says:")
        expect(page).to have_text(comment.body)
      end

      expect(page).to_not(
        have_link('Changes history', href: changes_history_path(entity_type: 'Comment', id: comment.id))
      )

      find(:xpath, "//a[@href='/projects/#{project.id}/comments/#{comment.id}/edit']").click

      expect(page).to have_selector('h1', text: 'Editing comment')

      new_comment_body = 'This is a new comment body'
      fill_in('comment[body]', with: new_comment_body)
      click_button('Update Comment')

      expect(page).to have_text('Comment was successfully updated.')
      within("#comment_#{comment.id}") do
        expect(page).to have_text("#{comment.user.email} says:")
        expect(page).to have_text(new_comment_body)
      end

      expect(page).to have_link('Changes history', href: changes_history_path(entity_type: 'Comment', id: comment.id))
    end
  end
end
