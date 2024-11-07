Fabricator(:comment) do
  body { FFaker::Lorem.sentence }
  project { Fabricate(:project) }
  user { Fabricate(:user) }
end
