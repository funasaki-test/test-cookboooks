wpdir = "/usr/bin/"

package "mysql" do
   action :install
end

package "mysql-devel" do
   action :install
end

package "ruby-mysql" do
   action :insall
end

execute "wp-cli install" do
   command "curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar && chmod +x wp-cli.phar && cp wp-cli.phar #{wpdir}/wp"
   cwd '/home/ec2-user'
   action :run
   not_if { ::File.exists?("#{wpdir}/wp")}
end


