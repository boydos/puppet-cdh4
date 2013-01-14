class cdh4::tasktracker($jobtracker_hostname) {
    require cdh4::repo
    require oracle-jdk

    File {
        owner => root,
        group  => hadoop
    }

    ensure_resource('package', 'hadoop-0.20-mapreduce-tasktracker', {'ensure' => 'present'})
    ensure_resource('file', '/etc/hadoop/conf.cluster', {'ensure' => 'directory'})

    ensure_resource(file, '/srv/dfs', {
        ensure  =>  directory,
        owner   =>  hdfs,
        group   =>  hdfs,
        mode    =>  755
        })

    ensure_resource(file, '/srv/dfs/mapred', {
        ensure  =>  directory,
        owner   =>  mapred,
        group   =>  hadoop,
        mode    =>  700,
        require =>  File['/srv/dfs']
        })

    file { "/etc/hadoop/conf.cluster/mapred-site.xml" :
        content => template("cdh4/hadoop/tasktracker/mapred-site.xml"),
        require => File['/etc/hadoop/conf.cluster', '/etc/hadoop/conf.cluster/core-site.xml' ]
    }

    exec { 'hdfs-update-alternatives-mapred' :
        command => "update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 50 && update-alternatives --set hadoop-conf /etc/hadoop/conf.cluster && touch /etc/hadoop/hadoop-config-loaded-mapred",
        require => File["/etc/hadoop/conf.cluster/mapred-site.xml"],
        provider => 'shell',
        creates => '/etc/hadoop/hadoop-config-loaded-mapred',
    }

    service { "hadoop-0.20-mapreduce-tasktracker" :
        ensure  => running,
        enable  => true,
        require =>  Exec["hdfs-update-alternatives-mapred"]
    }

}
