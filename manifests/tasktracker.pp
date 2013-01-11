class cdh4::tasktracker {
    require cdh4::repo
    require oracle-jdk

    ensure_resource('package', 'hadoop-0.20-mapreduce-tasktracker', {'ensure' => 'present'})

}
