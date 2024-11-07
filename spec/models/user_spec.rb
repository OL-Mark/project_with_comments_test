# TODO: It would be good to have specs for devise related functionality,
# however, I didn't add them due to time constraints.
RSpec.describe User do
  subject { Fabricate.build :user }

  it 'has a valid factory' do
    is_expected.to be_valid
  end

  describe 'Relationships' do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:projects).dependent(:destroy) }
  end
end
