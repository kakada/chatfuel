FactoryBot.define do
  factory :provincial_usage, class: ProvincialUsage do
    result { {} }
    pro_code { "" }

    initialize_with { new(result, pro_code) }
  end
end
