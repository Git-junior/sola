FactoryBot.define do
  factory :photo do
    content {Faker::Lorem.sentence}
    association :user

    after(:build) do |photo|
      photo.image.attach(io: File.open('public/images/test_image.JPG'), filename: 'test_image.JPG')
    end
  end
end
