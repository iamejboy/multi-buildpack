$: << 'cf_spec'
require 'yaml'
require 'spec_helper'

xdescribe 'running supply buildpacks before the dotnet-core buildpack' do
  let(:buildpack) { ENV.fetch('SHARED_HOST')=='true' ? 'multi_buildpack' : 'multi-test-buildpack' }
  let(:app) { Machete.deploy_app(app_name, buildpack: buildpack) }
  let(:browser) { Machete::Browser.new(app) }

  after { Machete::CF::DeleteApp.new.execute(app) }

  context 'the app is pushed once' do
    let (:app_name) { 'fake_supply_dotnet_app' }

    it 'finds the supplied dependency in the runtime container' do
      expect(app).to be_running
      expect(app).to have_logged "SUPPLYING BOSH2"

      browser.visit_path('/')
      expect(browser).to have_body(/bosh2: version 2.0.1-74fad57/)
    end
  end

end
