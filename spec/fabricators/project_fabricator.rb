Fabricator(:project) do
  title { FFaker::Lorem.sentence }
  description { FFaker::Lorem.paragraph }
  status { Project::VALID_STATUSES.sample }
  user { Fabricate(:user) }
end
