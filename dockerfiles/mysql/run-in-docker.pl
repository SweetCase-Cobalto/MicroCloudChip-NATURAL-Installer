
=pod
	idx-0: project root
	idx-1: server port
	idx-2: admin email
	idx-3: server host
	idx-4: storage root
=cut

my $projectRoot = shift;
my $serverPort = shift;
my $adminEmail = shift;
my $serverHost = shift;

# DB_ENV Section
my $DBname = shift;
my $DBuser = shift;
my $DBpswd = shift;
my $DBhost = shift;
my $DBport = shift;

my $storageRoot = shift;

chdir $projectRoot;

print `${DBport}\n`;
# if first (not installed)
unless( -e "app/server/server/config.json" ) {

	# if storage root is not exist (default root)
	if( $storageRoot eq "" ) {
		$storageRoot = "/storage";
	}

	mkdir "${storageRoot}/microcloudchip";
	mkdir "${storageRoot}/microcloudchip/storage";
	
	# setting config file
	chdir "${projectRoot}/bin";
	
	# config setting
	system "perl setConfigure-mysql.pl ${storageRoot}/microcloudchip ${serverPort} ${serverHost} ${adminEmail} ${DBhost} ${DBport} ${DBuser} ${DBpswd} ${DBname}";

	# build
	chdir "${projectRoot}/web";
	system "npm i";
	system "npm run build";

	# move to templates
	chdir "${projectRoot}/app/server";
	mkdir "templates";
	system "mv ${projectRoot}/web/build/* ./templates/";	
	
	# python setting
	system "python manage.py collectstatic";
	system "python manage.py makemigrations";
	system "python manage.py migrate";
}

# run
chdir "${projectRoot}/app/server";
system "gunicorn --bind 0:${serverPort} server.wsgi:application";
