# TODO: Controllers should be tested as well, however I skip this due to time constraints.
# Adding basic test cases structure below.
RSpec.describe HistoriesController, type: :controller do
  describe 'GET #show' do
    context 'when requesting histories for a project' do
      context 'when project exists' do
        it 'returns a successful response'
        it 'returns the history for the specified project'
      end

      context 'when project does not exist' do
        it 'returns a not found response'
      end
    end

    context 'when requesting histories for a comment' do
      context 'when comment exists' do
        it 'returns a successful response'
        it 'returns the history for the specified comment'
      end

      context 'when comment does not exist' do
        it 'returns a not found response'
      end
    end

    context 'when requesting histories for not valid entity' do
      it 'returns a not found response'
    end
  end
end
