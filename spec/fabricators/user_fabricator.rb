Fabricator(:user) do
  email 'user@example.com'
  full_name Faker.name
  password 'letmein'
  password_confirmation { |user| user.password }

end

