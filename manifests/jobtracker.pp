class cdh4::jobtracker {
    require cdh4::repo
    require oracle-jdk

    ensure_resource('package', 'hadoop-0.20-mapreduce-jobtracker', {'ensure' => 'present'})
}
