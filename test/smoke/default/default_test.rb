# # encoding: utf-8

# Inspec test for recipe rstomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/


# require 'spec_helper'

# describe 'rstomcat::default' do
  describe command("curl http://localhost:8080") do
    its(:stdout) { should match /Tomcat/ }
  end
# end

describe package('java-1.7.0-openjdk-devel') do
  it {should be_installed}
end

describe group('tomcat') do
  it {should exist}
end

describe user('tomcat') do
  it {should exist}
  it {should belong_to_group 'tomcat'}
end

describe file ('/opt/tomcat') do
  it {should exist}
  it {should be_directory}
end

describe file ('/opt/tomcat/conf') do
  it {should exist}
  it {should be_directory}
end

#$ sudo chown -R tomcat webapps/ work/ temp/ logs/
%w[webapps work temp logs].each do |path|
  describe file("/opt/tomcat/#{path}") do
    it {should exist}
    it {should be_owned_by 'tomcat'}
  end
end
