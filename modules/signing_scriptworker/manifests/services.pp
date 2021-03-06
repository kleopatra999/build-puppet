class signing_scriptworker::services {
    include ::config
    include signing_scriptworker::settings
    include packages::mozilla::supervisor

    supervisord::supervise {
        "signing_scriptworker":
            command      => "${signing_scriptworker::settings::root}/bin/scriptworker ${signing_scriptworker::settings::root}/config.json",
            user         => $::config::builder_username,
            require      => [ File["${signing_scriptworker::settings::root}/config.json"],
                              File["${signing_scriptworker::settings::root}/script_config.json"],
                              File["${signing_scriptworker::settings::root}/passwords.json"]],
            extra_config => template("${module_name}/supervisor_config.erb");
    }
    exec {
        "restart-scriptworker":
            command     => "/usr/bin/supervisorctl restart signing_scriptworker",
            refreshonly => true,
            subscribe   => [Python35::Virtualenv["${signing_scriptworker::settings::root}"],
                            File["${signing_scriptworker::settings::root}/config.json"],
                            File["${signing_scriptworker::settings::root}/script_config.json"],
                            File["${signing_scriptworker::settings::root}/passwords.json"]];
    }
}
