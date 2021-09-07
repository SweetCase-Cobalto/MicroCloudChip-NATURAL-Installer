# Setting Variables
my $PACKAGE_DIRNAME = '.microcloudchip';
my $WORKIND_DIRNAME = 'microcloudchip';

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


sub main {

    # Main Process
    my %config = getConfigData();

    unless(checkingConfigData(%config) == 1) {
        # 통과 못함
        return;
    }
    
}

main();