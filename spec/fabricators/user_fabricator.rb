Fabricator(:user) do
  email { FFaker::Internet.email }
  password { 'qwerty123' } # Make password the same for debugging purposes
end
