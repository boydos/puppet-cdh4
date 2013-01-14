class cdh4::zookeeper {
    require cdh4::repo
    require oracle-jdk

    ensure_resource('package', 'zookeeper-server',
        { ensure => present })

    exec { 'initialize-zookeeper' :
        command => 'service zookeeper-server init',
        creates => '/var/lib/zookeeper/version-2',
        require => Package['zookeeper-server']
    }

    service { 'zookeeper-server' :
        ensure  => running,
        enable  => true,
        require =>  Exec['initialize-zookeeper']
    }

}
