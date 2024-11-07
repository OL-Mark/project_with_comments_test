# TODO: It would be good to have specs for auditable,
# however, I didn't add them due to time constraints.
RSpec.describe Comment do
  subject { Fabricate :comment }

  it 'has a valid factory' do
    is_expected.to be_valid
  end

  describe 'Relationships' do
    it { is_expected.to belong_to(:user).required(true) }
    it { is_expected.to belong_to(:project).required(true) }
  end

  context 'when comment has been edited' do
    let(:comment) { Fabricate :comment }

    subject { comment.update!(body: 'This comment is edited') }

    it 'sets edited attribute to true' do
      expect { subject }.to change { comment.edited? }.from(false).to(true)
    end
  end
end
