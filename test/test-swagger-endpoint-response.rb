require_relative 'minitest-helper'
require_relative 'test-utilities'

require_relative '../lib/sinatra/swagger-exposer/swagger-endpoint-response'

class TestSwaggerEndpointResponse < Minitest::Test

  describe Sinatra::SwaggerExposer::SwaggerEndpointResponse do

    include TestUtilities

    it 'must fail with a bad type' do
      must_raise_swag_and_equal(
      -> { new_er(1, 'description', []) },
      'Type [1] of has an unknown type, should be a class, a string or an array'
      )
      must_raise_swag_and_equal(
      -> { new_er([1], 'description', []) },
      'Unknown type [1], possible types are integer, long, float, double, string, byte, boolean, date, dateTime, password'
      )
      must_raise_swag_and_equal(
      -> { new_er(nil, 'description', []) },
      'Type is nil'
      )
    end

    it 'must fail with a unknown type' do
      must_raise_swag_and_equal(
      -> { new_er('foo', 'description', []) },
      'Unknown type [foo], possible types are integer, long, float, double, string, byte, boolean, date, dateTime, password'
      )
      must_raise_swag_and_equal(
      -> { new_er(['foo'], 'description', []) },
      'Unknown type [foo], possible types are integer, long, float, double, string, byte, boolean, date, dateTime, password'
      )
    end

    it 'must return the right values' do
      new_er(String, nil, []).to_swagger.must_equal(
          {:schema => {:type => 'string'}}
      )
      new_er('string', nil, []).to_swagger.must_equal(
          {:schema => {:type => 'string'}}
      )
      new_er([String], nil, []).to_swagger.must_equal(
          {:schema => {:type => 'array', :items => {:type => 'string'}}}
      )
      new_er(['string'], nil, []).to_swagger.must_equal(
          {:schema => {:type => 'array', :items => {:type => 'string'}}}
      )
      new_er('foo', nil, ['foo']).to_swagger.must_equal(
          {:schema => {'$ref' => '#/definitions/foo'}}
      )
      new_er('foo', 'description', ['foo']).to_swagger.must_equal(
          {:schema => {'$ref' => '#/definitions/foo'}, :description => 'description'}
      )
      new_er(['foo'], 'description', ['foo']).to_swagger.must_equal(
          {:schema => {:type => 'array', :items => {'$ref' => '#/definitions/foo'}}, :description => 'description'}
      )
    end

    it 'must answer to to_s' do
      JSON.parse(new_er(['foo'], 'description', ['foo']).to_s).must_equal(
          {'type' => 'array', 'items' => 'foo', 'description' => 'description'}
      )
    end

  end

end
