class cdh4::jobtracker($jobtracker_hostname) {
    require cdh4::repo
    require oracle-jdk

    File {
        owner => root,
        group  => hadoop
    }

    ensure_resource('package', 'hadoop-0.20-mapreduce-jobtracker', {'ensure' => 'present'})
    ensure_resource('file', '/etc/hadoop/conf.cluster', {'ensure' => 'directory'})


    file { "/etc/hadoop/conf.cluster/mapred-site.xml" :
        content => template("cdh4/hadoop/jobtracker/mapred-site.xml"),
        require => File['/etc/hadoop/conf.cluster'],
        notify  =>  Service["hadoop-0.20-mapreduce-jobtracker"]
    }

    exec { 'hdfs-update-alternatives-mapred' :
        command => "update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 50 && update-alternatives --set hadoop-conf /etc/hadoop/conf.cluster && touch /etc/hadoop/hadoop-config-loaded",
        require => File['/etc/hadoop/conf.cluster/hdfs-site.xml'],
        provider => 'shell',
        creates => '/etc/hadoop/hadoop-config-loaded',
    }


    service { "hadoop-0.20-mapreduce-jobtracker" :
        ensure  => running,
        enable  => true,
        require =>  File["/etc/hadoop/conf.cluster/mapred-site.xml"]
    }



}
