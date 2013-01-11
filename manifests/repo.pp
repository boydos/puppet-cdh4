class cdh4::repo {

    exec { "download-cdh4-repo" :
        command => "wget http://s.brhelwig.com/3U1m1Q0n0U13/download/cdh4-repository_1.0_all.deb -O /usr/local/src/cdh4-repository_1.0_all.deb",
        creates => "/usr/local/src/cdh4-repository_1.0_all.deb",
        notify  => Exec["install-cdh4-repo"]
    }

    exec { "install-cdh4-repo" :
        command => "dpkg -i /usr/local/src/cdh4-repository_1.0_all.deb",
        refreshonly => true,
        notify  => Exec["cdh4-apt-get-update"]
    }

    exec { "cdh4-apt-get-update" :
        command => "apt-get update; #cdh4",
        refreshonly => true
    }

}
