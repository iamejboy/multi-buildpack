$: << 'cf_spec'
require 'yaml'
require 'spec_helper'

describe 'running supply buildpacks before the staticfile buildpack' do
  let(:buildpack) { ENV.fetch('SHARED_HOST')=='true' ? 'multi_buildpack' : 'multi-test-buildpack' }
  let(:app) { Machete.deploy_app(app_name, buildpack: buildpack) }
  let(:browser) { Machete::Browser.new(app) }

  after { Machete::CF::DeleteApp.new.execute(app) }

  context 'the app is pushed once' do
    let (:app_name) { 'fake_supply_staticfile_app' }

    it 'finds the supplied dependency in the runtime container' do
      expect(app).to be_running
      expect(app).to have_logged "SUPPLYING DOTNET"
      expect(app).to have_logged "dotnet: 1.0.1"

      browser.visit_path('/')
      expect(browser).to have_body("This is an example app for Cloud Foundry that is only static HTML/JS/CSS assets.")
    end
  end
end
