RSpec.describe 'Project', type: :feature, js: true do
  include CapybaraHelpers::Session

  let(:user) { Fabricate :user }

  before { sign_in_as user }

  describe 'Index' do
    let!(:projects) { Fabricate.times(3, :project, user: user) }

    context 'when visiting the root path' do
      it 'shows all existing projects' do
        visit root_path

        expect(page).to have_selector('h1', text: 'Projects')

        within('.projects_wrapper') do
          expect(page).to have_selector('.project_wrapper', count: projects.count)
        end
      end
    end
  end

  describe 'Create a new project' do
    let(:project_attributes) do
      {
        title: 'Tidy up the room',
        description: 'Mom told me to tidy up the room',
        status: 'planning',
        user_email: user.email
      }
    end

    let(:new_project) { user.projects.find_by(title: project_attributes[:title]) }

    it 'creates a new project and redirects to root path' do
      visit new_project_path

      expect(page).to have_selector('h1', text: 'New project')

      populate_project_form(project_attributes)
      click_on "Create Project"

      expect(page).to have_text('Project was successfully created.')

      validate_project_card(new_project.id, project_attributes)
    end
  end

  describe 'Edit project' do
    let!(:project) { Fabricate :project, user: user }
    let!(:my_brother) { Fabricate :user }

    let(:project_new_attributes) do
      {
        title: 'Make visibility that the room is clean',
        description: 'Mom told me to tidy up the room. (..but I do not want, so I need to delegate)',
        status: 'pending',
        user_email: my_brother.email
      }
    end

    it 'updates project' do
      visit edit_project_path(project)

      expect(page).to have_selector('h1', text: 'Editing project')
      populate_project_form(project_new_attributes)
      click_on 'Update Project'

      expect(page).to have_text('Project was successfully updated.')

      validate_project_card(project.id, project_new_attributes)
    end
  end

  describe 'Destroy project' do
    let!(:project) { Fabricate :project, user: user }

    it 'deletes project' do
      visit edit_project_path(project)

      click_button('Destroy this project')

      expect(page).to have_text('Project was successfully destroyed.')
      expect(page).to_not have_selector("#project_#{project.id}")

      expect(Project.where(id: project.id).exists?).to be_falsey
      expect(Comment.where(project_id: project.id).exists?).to be_falsey
    end
  end

  private

  def populate_project_form(params_hash)
    fill_in "project[title]",	with: params_hash[:title]
    fill_in "project[description]",	with: params_hash[:description]
    select params_hash[:status], from: 'project[status]'
    select params_hash[:user_email], from: 'project[user_id]'
  end

  def validate_project_card(project_id, expected_attributes)
    within("#project_#{project_id}") do
      expect(page).to have_text("Title: #{expected_attributes[:title]}")
      expect(page).to have_text("Description: #{expected_attributes[:description]}")
      expect(page).to have_text("Status: #{expected_attributes[:status]}")
      expect(page).to have_text("Assigned to: #{expected_attributes[:user_email]}")
    end
  end
end
