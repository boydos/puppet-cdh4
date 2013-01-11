class cdh4::namenode {
    require cdh4::repo
    require oracle-jdk

    ensure_resource('package', 'hadoop-hdfs-namenode', {'ensure' => 'present'})
}
