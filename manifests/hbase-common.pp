class cdh4::hbase-common($namenode_hostname, $zookeeper_peer) {
    require cdh4::repo
    require oracle-jdk

    ulimit::rule { 'hbase':
        ulimit_domain => 'hbase',
        ulimit_type   => '-',
        ulimit_item   => 'nofile',
        ulimit_value  => '1000000',
    }

    ensure_resource('file', '/etc/hbase', {'ensure' => 'directory'})
    ensure_resource('file', '/etc/hbase/conf.cluster', {'ensure' => 'directory'})

    file { "/etc/hbase/conf.cluster/hbase-site.xml" :
        content => template("cdh4/hbase/hbase-site.xml")
    }

    exec { 'hbase-update-alternatives' :
        command => "update-alternatives --install /etc/hbase/conf hbase-conf /etc/hbase/conf.cluster 50 && update-alternatives --set hbase-conf /etc/hbase/conf.cluster && touch /etc/hbase/hbase-config-loaded",
        require => File['/etc/hbase/conf.cluster/hbase-site.xml'],
        provider => 'shell',
        creates => '/etc/hbase/hbase-config-loaded',
    }

}
