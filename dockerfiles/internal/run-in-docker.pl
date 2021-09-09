
=pod
	idx-0: project root
	idx-1: server port
	idx-2: admin email
	idx-3: server host
	idx-4: storage root
=cut

my $projectRoot = $ARGV[0];
my $serverPort = $ARGV[1];
my $adminEmail = $ARGV[2];
my $serverHost = $ARGV[3];
my $storageRoot = $ARGV[4];

chdir $projectRoot;

# if first (not installed)
unless( -e "app/server/server/config.json" ) {
	# if storage root is not exist (default root)
	if( $storageRoot == "" ) {
		$storageRoot = "/storage";
	}

	mkdir "${storageRoot}/microcloudchip";
	mkdir "${storageRoot}/microcloudchip/storage";
	
	# setting config file
	chdir "${projectRoot}/bin";
	
	# config setting
	system "perl setConfigure-sqlite.pl ${storageRoot}/microcloudchip ${serverPort} ${serverHost} ${adminEmail}";

	# build
	chdir "${projectRoot}/web";
	system "npm run build";

	# move to templates
	mkdir "${projectRoot}/app/server/templates";
	chdir $projectRoot;
	system "mv ./web/build/* ./app/server/templates/";	
	
	# python setting
	chdir "app/server";
	system "python manage.py collectstatic";
	system "python manage.py makemigrations";
	system "python manage.py migrate";
}

# run
chdir "${storageRoot}/app/server";
system "gunicorn --bind 0:${serverPort} server.wsgi:application";