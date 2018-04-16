RSpec.describe Api::V1::PropertiesController do
  describe 'GET index', type: :request do
    context 'when user have properties' do
      let!(:user) { create(:user, login: 'peter') }
      let!(:another_user) { create(:user, login: 'chris') }

      let!(:property1) { create(:property, user: user, title: 'prop1') }
      let!(:property2) { create(:property, user: user, title: 'prop2') }
      let!(:property3) { create(:property, user: another_user) }

      # Assume that user already authenticated
      let!(:session) { create(:user_session, user: user) }

      before do
        get(
          '/api/properties',
          params: {
            auth_key: session.auth_key,
          }
        )
      end

      specify 'should return status 200' do
        expect(response.status).to eq(200)
      end

      specify 'should return json with only user\'s properties' do
        properties = JSON.parse(response.body).symbolize_keys[:properties]
        properties = JSON.parse(properties)

        expect(properties).to eql(
          [
            {
              'id' => property1.id,
              'title' => property1.title,
              'value' => property1.value
            },
            {
              'id' => property2.id,
              'title' => property2.title,
              'value' => property2.value
            }
          ]
        )
      end
    end
  end

  describe 'POST create', type: :request do
    context 'if all data is valid' do
      let(:title) { 'beach' }
      let(:value) { 355 }
      let!(:user) { create(:user, login: 'ozzy') }

      # Assume that user already authenticated
      let!(:session) { create(:user_session, user: user) }

      before do
        post(
          '/api/properties/',
          params: {
            auth_key: session.auth_key,
            title: title,
            value: value,
          }
        )

        @properties = user.properties
      end

      specify 'should return status 200' do
        expect(response.status).to eq(200)
      end

      specify 'should create one new property for user' do
        expect(@properties.size).to eq(1)
        expect(@properties[0].title).to eq(title)
        expect(@properties[0].value).to eq(value)
      end

      specify 'should return json with user_id' do
        expect(JSON.parse(response.body).symbolize_keys).to eq(
          { property_id: @properties[0].id }
        )
      end
    end
  end
end
