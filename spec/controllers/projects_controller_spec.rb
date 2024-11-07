# TODO: Controllers should be tested as well, however I skip this due to time constraints.
# Adding basic test cases structure below.
RSpec.describe ProjectsController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response'
    it 'returns all projects'
  end

  describe 'GET #show' do
    context 'when project exists' do
      it 'returns a successful response'
    end

    context 'when project does not exist' do
      it 'returns a not found response'
    end
  end

  describe 'GET #new' do
    it 'returns a successful response'
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Project'
      it 'redirects to the created project'
    end

    context 'with invalid parameters' do
      it 'does not create a new Project'
      it 're-renders the new template'
    end
  end

  describe 'GET #edit' do
    context 'when project exists' do
      it 'returns a successful response'
    end

    context 'when project does not exist' do
      it 'returns a not found response'
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested project'
      it 'redirects to the project'
    end

    context 'with invalid parameters' do
      it 'does not update the project'
      it 're-renders the edit template'
    end
  end

  describe 'DELETE #destroy' do
    context 'when project exists' do
      it 'destroys the requested project'
      it 'redirects to the projects list'
    end

    context 'when project does not exist' do
      it 'returns a not found response'
    end
  end

  describe 'GET #search' do
    context 'with search query' do
      it 'returns projects matching the search query'
    end

    context 'without search query' do
      it 'returns all projects'
    end
  end
end
