class cdh4::hbase-master {
    require cdh4::hbase-common
    require cdh4::zookeeper

    ensure_resource('package', 'hbase-master', {'ensure' => 'present'})

    service { 'hbase-master' :
        ensure  => running,
        enable  => true,
        require => Service['zookeeper-server']
    }
}
