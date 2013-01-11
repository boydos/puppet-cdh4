class cdh4::secondarynamenode {
    require cdh4::repo
    require oracle-jdk

    ensure_resource('package', 'hadoop-hdfs-secondarynamenode', {'ensure' => 'present'})

}
