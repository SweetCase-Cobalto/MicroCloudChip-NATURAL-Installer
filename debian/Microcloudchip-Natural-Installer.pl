#!/usr/bin/perl
use experimental qw(switch);

# Setting Variables
my $PACKAGE_DIRNAME = '.microcloudchip';
my $WORKING_DIRNAME = 'microcloudchip';

my @DEPENDENCY_PACKAGES = ['git', 'python3-dev', 'libmysqlclient-dev', 'gcc'];

# Err Msg
my $CONFIG_ERR_PREFIX = "[Config Err]: ";

sub getConfigData {
    # Config.cfg 로부터 데이터 갖고오기
    
    my %configData = (); # Return Value
    my $filename = "config.cfg";

    # 파일이 없는 경우
    unless(-e $filename) {
        print "Config File Does Not Exist\n";
        exit(0);
    }
    open FH, '<', $filename or die $!;
    
    # 데이터 받기
    while(<FH>) {
        my $line = $_;
        my @splited = split(":", $line);
        
        # Result Value에 추가
        my $value = $splited[1];
        chomp($value);
        $configData{$splited[0]} = $value;
    }
    close(FH);

    return %configData;
}
sub checkingConfigData {
    # config data 검토
    # 통과 시 True, 실패 시 False
    my %config = @_;

    # port Checking
    my $port = $config{'port'};
    unless(defined $port) {
        print $CONFIG_ERR_PREFIX . "Port Data is not exist, please check coinfig.cfg\n";
        return 0;
    }
    # is Port digit?
    unless(($port =~ /^\d*$/) == 1) {
        print $CONFIG_ERR_PREFIX . "Port Data must be number. please check config.cfg\n";
        return 0;
    }
    # is Port in range?
    unless(1024 < int($port) and int($port) < 49151) {
        print $CONFIG_ERR_PREFIX . "This port number can't be used\n";
        return 0;
    }

    # Storage-Root Checking
    my $storageRoot = $config{'storage-root'};
    unless(defined $storageRoot) {
        print $CONFIG_ERR_PREFIX . "Storage root is not exist. please check config.cfg\n";
        return 0;
    }

    # is storageRoot is directory
    unless( -d $storageRoot) {
        print $CONFIG_ERR_PREFIX . "This Storage root is not directory. It must be directory root\n";
        return 0;
    }
    $config{'storage-root'} = $storageRoot;

    # Check Database Type
    my $databaseType = $config{'database-type'};
    unless(defined $databaseType) {
        print $CONFIG_ERR_PREFIX . "Database type is not exist. please check config.cfg\n";
        return 0;
    }
    
    # value check
    unless($databaseType == 'internal' || $databaseType == 'mysql') {
        print $CONFIG_ERR_PREFIX . "Database type can be writed only 'internal' and 'mysql' \n";
    }
    return 1;
}
sub makeWorkingDirectory {
    # 프로그램이 정상적으로 돌아갈 디렉토리를 생성한다
    my $homeRoot = $ENV{'HOME'};

    my $realPackageRoot = $homeRoot . '/' . $PACKAGE_DIRNAME;
    my $realWorkingRoot = $homeRoot . '/' . $WORKING_DIRNAME;

    # 디렉토리 생성
    unless( -d $realPackageRoot ) {
        system "mkdir $realPackageRoot";
    } else {
        # 디렉토리 비우기
        system "rm -rf $realPackageRoot";
        system "mkdir $realPackageRoot";
    }
    unless( -d $realWorkingRoot ) {
        system "mkdir $realWorkingRoot";
    } else {
        system "rm -rf $realWorkingRoot";
        system "mkdir $realWorkingRoot";
    }

    my %roots = (
        'workingRoot' => $realWorkingRoot,
        'packageRoot' => $realPackageRoots
    );
    return %roots;
}
sub makeStorageRoot {
    my $storageParentRoot = shift;
    my $storageRoot = $storageParentRoot . '/' . $WORKING_DIRNAME;

    # 이미 있는 경우 포맷한 다음 다시 생성
    if( -e $storageRoot ) {
        system "rm -rf $storageRoot";
    }
    system "mkdir $storageRoot";

    # 하위 디렉토리 생성
    my $staticFilesRoot = $storageRoot . '/web';
    my $userStorageRoot = $storageRoot . '/storage';

    system "mkdir $staticFilesRoot";
    system "mkdir $userStorageRoot";


    my %storageRoots = (
        'storageRoot' => $storageRoot,
        'staticFilesRoot' => $staticFilesRoot,
        'userStorageRoot' => $userStorageRoot
    );
    return %storageRoots;
}

sub installDependencyPackage {
    
}

sub installApp {
    # installer
    
    # Main Process
    my %config = getConfigData();
    unless(checkingConfigData(%config) == 1) {
        # 통과 못함
        return;
    }
    # make working directory
    my %workingRoots = makeWorkingDirectory();

    # make storage directory
    my %storageRoots = makeStorageRoot($config{'storage-root'});

    # install dependency
    installDependencyPackage();
}

sub removeDependencyPackage {
    print $OSNAME;
}

sub formatApp {
    # formatter

    # get data
    my %config = getConfigData();
    unless(checkingConfigData(%config) == 1) {
        return;
    }

    my $homeRoot = $ENV{"HOME"};

    # working directory remove
    my $realPackageRoot = $homeRoot . '/' . $PACKAGE_DIRNAME;
    my $realWorkingRoot = $homeRoot . '/' . $WORKING_DIRNAME;

    if( -e $realPackageRoot ) {
        system "rm -rf $realPackageRoot";
    }
    if( -e $realWorkingRoot ) {
        system "rm -rf $realWorkingRoot";
    }

    # remove storage root
    my $storageRoot = $config{'storage-root'} . '/' . $WORKING_DIRNAME;
    if( -e $storageRoot ) {
        system "rm -rf $storageRoot";
    }
}

sub main {
    # main process
    my $cmd = $ARGV[0];

    given($cmd) {
        when ('install') {
            installApp();
        } when ('format') {
            formatApp();
        } default {
            print "install: install application\n";
            print "format: remove application\n";
        }
    }
}

main();