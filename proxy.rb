require 'sinatra'
require 'json'
require 'yaml'

def initialize
  super()
  @memorystore = {}
end

# Key checks
def check_key(key)
  config = YAML.load_file 'keys.yml'
  halt 401 if key != config['key']
end

# Save
def save(hash)
  @memorystore = hash
end

# Create register if it doesn't exist
puts 'Starting up...'

get '/register' do
  headers\
    'Server' => 'RP'
  content_type :json
  check_key params[:key]
  halt 500 if !params[:id] || !params[:hname]
  register = @memorystore || {}
  register[params[:hname]] = {}
  register[params[:hname]]['id'] = params[:id]
  save register
  { message: 'registered' }.to_json
end

get '/deregister' do
  headers\
    'Server' => 'RP'
  content_type :json
  check_key params[:key]
  halt 500 unless params[:hname]
  register = @memorystore
  register.delete(params[:hname])
  save register
  { message: 'deleted' }.to_json
end

get '/api' do
  headers\
    'Server' => 'RP'
  content_type :json
  register = @memorystore
  register.to_json
end