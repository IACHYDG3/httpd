require 'chefspec'
require 'chefspec/berkshelf'
require 'fauxhai'
require 'simplecov'
require 'simplecov-console'
# require 'coveralls'

RSpec.configure do |c|
  c.color = true
  c.before(:each) do
    # Don't worry about external cookbook dependencies
    # allow_any_instance_of(Chef::Cookbook::Metadata).to receive(:depends)

    # Prep lookup() for the stubs below
    allow_any_instance_of(Chef::ResourceCollection).to receive(:lookup)
      .and_call_original

    # Test each recipe in isolation, regardless of includes
    @included_recipes = []
    allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?)
      .and_return(false)
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe) do |_, i|
      allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?)
        .with(i)
        .and_return(true)
      @included_recipes << i
    end
    allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipes)
      .and_return(@included_recipes)
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    # Coveralls::SimpleCov::Formatter,
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
)
SimpleCov.minimum_coverage 90
SimpleCov.start do
  add_filter 'libraries/'
end

at_exit { ChefSpec::Coverage.report! }
