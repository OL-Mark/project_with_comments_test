RSpec.describe 'ApplicationController authentication before_action filter', type: :feature, js: true do
  include CapybaraHelpers::Session

  let!(:projects) do
    Fabricate.times(3, :project)
  end

  let!(:comments) do
    projects.map do |project|
      Fabricate.times(3, :comment, project: project)
    end
  end

  context 'when user is not logged in' do
    shared_examples_for 'showing login form' do
      before { visit target_path }

      it 'shows login form' do
        expect(page).to have_text('Log in')
        expect(page).to have_text('Email')
        expect(page).to have_field('user[email]')
        expect(page).to have_text('Password')
        expect(page).to have_field('user[password]')
        expect(page).to have_link('Sign up')
        expect(page).to have_button('Log in')
        expect(page).to have_link('Forgot your password?')
      end
    end

    context 'when visiting the root path' do
      let(:target_path) { root_path }

      it_behaves_like 'showing login form'
    end

    context 'when visiting the projects path' do
      let(:target_path) { projects_path }

      it_behaves_like 'showing login form'
    end

    context "when visiting a project's changes history" do
      let(:project) { projects.first }
      let(:target_path) { changes_history_path(entity_type: :project, id: project.id) }

      before { project.update!(description: 'New description') }

      it_behaves_like 'showing login form'
    end

    context "when visiting a project's comment page" do
      let(:project) { projects.first }
      let(:comment) { project.comments.last }
      let(:target_path) { project_comment_path(project_id: project.id, id: comment.id) }

      it_behaves_like 'showing login form'
    end

    context 'when visiting edit comment page' do
      let(:project) { projects.first }
      let(:comment) { project.comments.last }
      let(:target_path) { edit_project_comment_path(project_id: project.id, id: comment.id) }

      it_behaves_like 'showing login form'
    end

    context "when visiting a comment's changes history" do
      let(:project) { projects.first }
      let(:comment) { project.comments.last }
      let(:target_path) { changes_history_path(entity_type: :comment, id: comment.id) }

      before { comment.update!(body: 'New body') }

      it_behaves_like 'showing login form'
    end
  end

  context 'when user is logged in' do
    let(:current_user) { Fabricate(:user) }

    before { sign_in_as current_user }

    shared_examples_for 'showing projects' do
      it 'shows all existing projects' do
        expect(page).to have_selector('h1', text: 'Projects')

        within('.projects_wrapper') do
          expect(page).to have_selector('.project_wrapper', count: projects.count)
        end
      end
    end

    context 'when visiting the root path' do
      let(:target_path) { root_path }

      it_behaves_like 'showing projects'
    end

    context 'when visiting the projects path' do
      let(:target_path) { projects_path }

      it_behaves_like 'showing projects'
    end

    context "when visiting a project's changes history" do
      let(:project) { projects.first }
      let!(:old_project_description) { project.description }

      before { project.update!(description: 'New description') }

      it 'shows history entries' do
        visit changes_history_path(entity_type: :project, id: project.id)

        within('.history_entries') do
          expect(page).to have_selector('.history_entry', count: project.audits.count)
          expect(page).to have_text(old_project_description)
          expect(page).to have_text('New description')
        end
      end
    end

    context "when visiting a project's comment page" do
      let(:project) { projects.first }
      let(:comment) { project.comments.last }

      before { visit project_comment_path(project_id: project.id, id: comment.id) }

      it "shows comment with it's contents" do
        expect(page).to have_text("#{comment.user.email} says:")
        expect(page).to have_text(comment.body)
      end
    end

    context 'when visiting edit comment page' do
            let(:project) { projects.first }
      let(:comment) { project.comments.last }

      before { visit edit_project_comment_path(project_id: project.id, id: comment.id) }

      it "shows comment with it's contents" do
        expect(page).to have_selector('h1', text: 'Editing comment')
        expect(page).to have_text(comment.body)
      end
    end

    context "when visiting a comment's changes history" do
      let(:project) { projects.first }
      let(:comment) { project.comments.last }
      let!(:old_comment_body) { comment.body }

      before { comment.update!(body: 'I did not say that!') }

      it 'shows history entries' do
        visit changes_history_path(entity_type: :comment, id: comment.id)

        within('.history_entries') do
          expect(page).to have_selector('.history_entry', count: comment.audits.count)
          expect(page).to have_text(old_comment_body)
          expect(page).to have_text('I did not say that!')
        end
      end
    end
  end
end
