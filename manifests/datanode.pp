class cdh4::datanode {
    require cdh4::repo
    require oracle-jdk

    ensure_resource('package', 'hadoop-hdfs-datanode', {'ensure' => 'present'})
}
