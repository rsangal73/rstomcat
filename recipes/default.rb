#
# Cookbook:: rstomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# sudo yum install java-1.7.0-openjdk-devel
package 'java-1.7.0-openjdk-devel'

# sudo groupadd chef
# sudo useradd -g chef chef
group 'tomcat'
user 'tomcat' do
  group 'tomcat'
end

#cd /tmp
# wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/
#https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33-deployer.tar.gz

remote_file '/tmp/apache-tomcat-8.5.9.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz'
  not_if { File.exist?('/tmp/apache-tomcat-8.5.9.tar.gz' )}

end

#sudo mkdir /opt/tomcat
#$ sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

directory '/opt/tomcat' do
    action :create
end

execute 'tar xvf /tmp/apache-tomcat-8.5.9.tar.gz -C /opt/tomcat --strip-components=1'

#Update the Permissions
#$ sudo chgrp -R tomcat conf
#$ sudo chmod g+rwx conf
#$ sudo chmod g+r conf/*
#$ sudo chown -R tomcat webapps/ work/ temp/ logs/

execute 'chgrp -R tomcat /opt/tomcat/conf'
directory '/opt/tomcat/conf' do
  mode '0070'
end

execute 'chmod g+r /opt/tomcat/conf/*'
#execute 'chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'
execute 'chown -R tomcat /opt/tomcat/'

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

#$ sudo systemctl daemon-reload
#$ sudo systemctl start tomcat
#$ sudo systemctl enable tomcat

execute 'systemctl daemon-reload'

execute 'chmod -R +x /opt/tomcat/'

service 'tomcat' do
  action [:start, :enable]
end

#execute 'curl http://localhost:8080'
#Verify that Tomcat is running by visiting the site
#$ curl http://localhost:8080
