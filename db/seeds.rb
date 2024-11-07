# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.transaction do
  Fabricate :user, email: 'demo@example.com', password: 'qwerty123'
  Fabricate.times 5, :project

  Project.find_each do |project|
    project.update!(status: Project::VALID_STATUSES.sample) if rand(0..1) == 1
    Fabricate.times 5, :comment, project: project
  end

  Comment.find_each do |comment|
    next if rand(0..1) == 1

    comment.update!(body: FFaker::Lorem.words(rand(1..5)).join(' '))
  end
end
