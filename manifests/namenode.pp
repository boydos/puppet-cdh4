class cdh4::namenode($namenode_hostname) {

    require cdh4::repo
    require oracle-jdk

    File {
        owner => root,
        group  => hadoop
    }

    ensure_resource('package', 'hadoop-hdfs-namenode', {'ensure' => 'present'})
    ensure_resource('file', '/etc/hadoop/conf.cluster', {'ensure' => 'directory'})

    ensure_resource(file, '/srv/dfs', {
        ensure  =>  directory,
        owner   =>  hdfs,
        group   =>  hdfs,
        mode    =>  700,
        })


    ensure_resource(file, '/srv/dfs/nn', {
        ensure  =>  directory,
        owner   =>  hdfs,
        group   =>  hdfs,
        mode    =>  700,
        require =>  File['/srv/dfs']
        })

    file { "/etc/hadoop/conf.cluster/core-site.xml" :
        content => template("cdh4/hadoop/namenode/core-site.xml"),
        require => File['/etc/hadoop/conf.cluster']
    }

    file { "/etc/hadoop/conf.cluster/masters" :
        content => template("cdh4/hadoop/namenode/masters"),
        require => File['/etc/hadoop/conf.cluster']
    }

    file { "/etc/hadoop/conf.cluster/hdfs-site.xml" :
        content => template("cdh4/hadoop/namenode/hdfs-site.xml"),
        require => File['/etc/hadoop/conf.cluster', '/etc/hadoop/conf.cluster/core-site.xml' ]
    }

    exec { 'hdfs-update-alternatives' :
        command => "update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 50 && update-alternatives --set hadoop-conf /etc/hadoop/conf.cluster && touch /etc/hadoop/hadoop-config-loaded",
        require => File['/etc/hadoop/conf.cluster/hdfs-site.xml'],
        provider => 'shell',
        creates => '/etc/hadoop/hadoop-config-loaded',
    }

    exec { 'format-nameode' :
        command => "echo N | hadoop namenode -format",
        creates => '/srv/dfs/nn/current',
        user    => 'hdfs',
        group   => 'hdfs',
        provider => 'shell',
        require => Exec['hdfs-update-alternatives']
    }

    service { "hadoop-hdfs-namenode" :
        ensure  => running,
        enable  => true,
        require =>  Exec["format-nameode"]
    }


}
