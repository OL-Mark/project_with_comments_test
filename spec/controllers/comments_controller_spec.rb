
# TODO: Controllers should be tested as well, however I skip this due to time constraints.
# Adding basic test cases structure below.
RSpec.describe CommentsController, type: :controller do
  let(:user) { Fabricate :user }

  before { sign_in user }

  describe 'GET #show' do
    context 'when comment exists' do
      it 'returns a successful response'
    end

    context 'when comment does not exist' do
      it 'returns a not found response'
    end
  end

  describe 'GET #new' do
    it 'returns a successful response'
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Comment'
      it 'redirects to the created comment'
    end

    context 'with invalid parameters' do
      it 'does not create a new Comment'
      it 're-renders the new template'
    end
  end

  describe 'GET #edit' do
    context 'when comment exists' do
      it 'returns a successful response'
    end

    context 'when comment does not exist' do
      it 'returns a not found response'
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested comment'
      it 'redirects to the comment'
    end

    context 'with invalid parameters' do
      it 'does not update the comment'
      it 're-renders the edit template'
    end
  end
end
