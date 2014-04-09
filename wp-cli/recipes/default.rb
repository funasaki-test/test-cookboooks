wpdir = "/usr/bin/"

execute "wp-cli install" do
   command "curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar && chmod +x wp-cli.phar && cp wp-cli.phar #{wpdir}/wp"
   cwd '/home/ec2-user'
   action :run
   not_if { ::File.exists?("#{wpdir}/wp")}
end


