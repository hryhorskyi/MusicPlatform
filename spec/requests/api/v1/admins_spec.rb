# frozen_string_literal: true

xdescribe 'Admin', swagger_doc: 'v1/swagger_admin.yaml' do
  path '/api/v1/admin/login' do
    post 'sign in' do
      tags 'Admin'
      consumes 'application/json'
      parameter name: :admin, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '201', 'admin created' do
        let(:admin) { { email: 'email', password: 'password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:admin) { { email: 'email' } }
        run_test!
      end
    end
  end

  path '/api/v1/admin/admin_user/create' do
    post 'create admin' do
      tags 'Admin'
      consumes 'application/json'
      parameter name: :admin, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '201', 'admin created' do
        let(:admin) { { email: 'email', password: 'password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:admin) { { email: 'email' } }
        run_test!
      end
    end
  end

  path '/api/v1/admin/admin_user/{id}' do
    get 'current admin' do
      tags 'Admin'
      produces 'application/json', 'application/xml'
      parameter name: :id, in: :path, type: :string

      response '200', 'admin found' do
        schema type: :object,
               properties: {
                 email: { type: :string },
                 password: { type: :string }
               },
               required: %w[id email password]

        let(:id) { Admin.create(email: 'email', password: 'password').id }
        run_test!
      end

      response '404', 'admin not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
