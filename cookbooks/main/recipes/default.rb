#include_recipe 'rbenv::default'
#include_recipe 'rbenv::ruby_build'
include_recipe 'postgresql::server'
include_recipe 'postgresql::client'
include_recipe 'database::postgresql'
include_recipe 'nvm'

# Should probably configure languages before postgres is installed to avoid this.
execute 'Update locale' do
  command 'update-locale LANG=en_US.utf8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.utf8'
end

execute 'Psql template1 to UTF8' do
  user 'postgres'
  command <<-SQL
  echo "
  UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
  DROP DATABASE template1;
  CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE' LC_CTYPE='en_US.utf8' LC_COLLATE='en_US.utf8';
  UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';
  \\c template1
  VACUUM FREEZE;" | psql postgres -t
  SQL
end


# Set up database users, development database, and test database.
postgresql_connection_info = { :host => "localhost", :port => node['postgresql']['config']['port'], :username => 'postgres', :password => 'password' }

postgresql_database_user 'vagrant' do
  connection postgresql_connection_info
  password 'vagrant'
  role_attributes :superuser => true, :createdb => true
  action :create
end

# postgresql_database_user 'vagrant' do
#   connection postgresql_connection_info
#   password 'vagrant'
#   action :create
# end

# postgresql_database 'db_dev' do
#   connection postgresql_connection_info
#   template 'template1'
#   encoding 'UNICODE'
#   tablespace 'DEFAULT'
#   connection_limit '-1'
#   owner 'vagrant'
#   action :create
# end

# postgresql_database 'db_test' do
#   connection postgresql_connection_info
#   template 'template1'
#   encoding 'UNICODE'
#   tablespace 'DEFAULT'
#   connection_limit '-1'
#   owner 'vagrant'
#   action :create
# end

# postgresql_database_user 'vagrant' do
#   connection postgresql_connection_info
#   database_name 'db_dev'
#   action :grant
# end

# postgresql_database_user 'vagrant' do
#   connection postgresql_connection_info
#   database_name 'db_test'
#   action :grant
# end

nvm_install 'v0.10.5'  do
    from_source false
    alias_as_default true
end