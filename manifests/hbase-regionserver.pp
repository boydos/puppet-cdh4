class cdh4::hbase-regionserver {
    require cdh4::hbase-common

    ensure_resource('package', 'hbase-regionserver', {'ensure' => 'present'})

    service { 'hbase-regionserver' :
        ensure  => running,
        enable  => true,
        require => Package["hbase-regionserver"]
    }
}
