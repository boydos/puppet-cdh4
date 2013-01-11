class cdh4::client {
    require cdh4::repo
    require oracle-jdk

    ensure_resource('package', 'hadoop-client', {'ensure' => 'present'})

}
