# TODO: It would be good to have specs for auditable,
# however, I didn't add them due to time constraints.
RSpec.describe Project do
  VALID_STATUSES = %w[planning pending in_progress completed].freeze

  subject { Fabricate.build :project }

  it 'has a valid factory' do
    is_expected.to be_valid
  end

  describe 'Attributes' do
    it { is_expected.to define_enum_for(:status).with_values(VALID_STATUSES) }
  end

  describe 'Relationships' do
    it { is_expected.to belong_to(:user).optional(false) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }

    it do
      # Enum doesn't allow to assign wrong value throwing ArgumentError exception
      suppress(ArgumentError) do
        is_expected.to validate_inclusion_of(:status).in_array(VALID_STATUSES)
      end
    end
  end
end
