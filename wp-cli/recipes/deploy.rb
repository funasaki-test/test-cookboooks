require "net/http"
require "uri"

wpdir = "/srv/www/wordpress/current"
dbname = node[:mysql][:dbname]
dbuser = node[:mysql][:dbuser]
dbpass = node[:mysql][:dbpass]
dbhost = node[:mysql][:dbhost]
wp_admin_email = node[:wordpress_custom][:wp_admin_email]

execute "wp configure" do
   command "wp core config --dbname=#{dbname} --dbuser=#{dbuser} --dbpass=#{dbpass} --dbhost=#{dbhost}"
   cwd "#{wpdir}"
   user "deploy"
   not_if { File.exists?("#{wpdir}/wp-config.php") }
   action :run
end


uri = URI.parse("http://169.254.169.254/latest/meta-data/public-hostname")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)

public_hostname = response.body

execute "db create" do
   command "wp db create"
   cwd "#{wpdir}"
   user "deploy"
   action :run
   ignore_failure true
end

execute "wp deploy" do
   command "wp core install --url=#{public_hostname} --title=Test --admin_name=admin --admin_password=admin --admin_email=#{wp_admin_email}"
   cwd "#{wpdir}"
   user "deploy"
   action :run
   not_if "sudo -u deploy wp core is-installed --path=#{wpdir}"
end
