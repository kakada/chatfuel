FactoryBot.define do
  factory :provincial_usages, class: ProvincialUsages do
    provincial_usages { [] }

    initialize_with { new(provincial_usages) }
  end
end
