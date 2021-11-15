RSpec.shared_context "shared omniauth", :shared_context => :metadata do
  let!(:role) { create(:role, :site_ombudsman) }

  let(:auth) do
    { 
      provider: "instedd", 
      uid: "https://login.instedd.org/openid/user@instedd.org",
      info: {
        email: "user@instedd.org"
      }
    }.with_indifferent_access
  end
end