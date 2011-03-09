# vi: expandtab ts=4 sw=4 ai

class mysql
{
    tag("mysql")
    #we want to override the server_id in case of databrick setups.
    $__server_id = 1
    #There is no way to reconfigure the mysql user-rights through puppet 
    #after the initial setup (READ: i didnt make it)
    #so I am including all users in the default setup, to be sure we have everything.
    file { "/usr/share/mysql/mysql_system_tables_data.sql":
        content => template(
            "mysql/mysql_system_tables_data-header.sql.erb",
            "mysql/mysql_system_tables_data-vagrant.sql.erb",
            "mysql/mysql_system_tables_data-footer.sql.erb"
        )
    }

    exec { "install_db":
        command => "/usr/bin/mysql_install_db --user mysql --skip-name-resolve --verbose",
        creates => "/var/lib/mysql/mysql/user.frm",
        subscribe => File["/usr/share/mysql/mysql_system_tables_data.sql"]
    }

    file{"/var/log/mysql":
        ensure => directory,
        owner => mysql,
        group => mysql,
        mode => 755
    }

    service { "mysql":
       enable => true,
       ensure => running,
       hasrestart => true,
       hasstatus => true,
       require => [
            Exec["install_db"],
            File["/etc/mysql/my.cnf"],
            File["/etc/mysql/my5-server.cnf"],
            File["/etc/conf.d/mysql"],
            ]
   }

   file { "/etc/conf.d/mysql":
       content => template("mysql/mysql-conf.d.erb")
   }

   file { "/etc/mysql/my5-client.cnf":
       source => "modules/mysql/my5-client.cnf"
   }

   file { "/etc/mysql/my.cnf":
       source => "modules/mysql/my.cnf"
   }

   file { "/etc/mysql/my5-tools.cnf":
        source => "modules/mysql/my5-tools.cnf"
   }


   #The mysql configs are defided into 4 parts,
   #Base template, used for generic variables (excluding replication)
   #myisam, used for all myisam specific variables.
   #innodb, used for all innodb specific variables
   #replication, used for all replication specific variables

    $__db_store = "xtradb"

    #specify defaults for the variables used in the base template
    $__slow_query_log = "0"

    $__relay_log = "/var/lib/mysql/mysqld-relay-bin"
    $__relay_log_index = "/var/lib/mysql/mysqld-relay-bin.index"
    $__relay_log_info_file = "/var/lib/mysql/relay-log.info"
    $__relay_log_space_limit = "4G"
    $__max_relay_log_size = "1G"
    $__base_tmpdir = "/var/lib/mysql"
    $__base_slave_load_tmpdir = "/var/lib/mysql"
    $__base_port = "3306"

    $__base_net_buffer_length = "2M"
    $__base_read_buffer_size = "2M"
    $__base_read_rnd_buffer_size = "2M"
    $__base_thread_stack = "128K"
    $__base_back_log = "16384"
    $__base_open_files_limit = "2208"

    $__base_wait_timeout = "60"
    $__base_interactive_timeout = "28800"
    $__base_connect_timeout = "5"

    $__base_table_cache = 1024
    $__base_table_definition_cache = 1024
    $__base_sort_buffer_size = "8M"
    $__base_max_connections = "150"

    $__base_thread_cache = "20"
    $__base_query_cache_size = "0M"
    $__base_tmp_table_size = "32M"
    $__base_max_heap_table_size = "32M"

    $__base_slave_skip_errors = "0"
    $__base_low_priority_updates = "0"

    $__base_default_storage_engine = "innodb"

    $__master_info_file = "/var/lib/mysql/master.info"
    #specify in an array, which tables you want replication to ignore, format:  db.table
    $__replication_replicate_ignore_table = []
    #specify in an array, which tables you want to replicate, all table not specified but in the replication stream are ignored. format: db.table
    $__replication_replicate_do_table = []

    #specify defaults for myisam
    $__myisam_key_buffer = "2M"
    $__myisam_sort_buffer_size = "1M"


    #specify defaults for the innodb template
    $__innodb_log_file_size = "50M"
    $__innodb_log_buffer_size = "8M"
    $__innodb_log_group_home_dir = "/var/lib/mysql"
    $__innodb_buffer_pool_size = "250M"
    $__innodb_additional_mem_pool_size = "10M"
    $__innodb_file_per_table = "1"
    $__innodb_flush_log_at_trx_commit = "0"

    #specify defaults for the xtradb template
    $__innodb_flush_method = "O_DIRECT"
    $__innodb_adaptive_checkpoint = "1"
    $__innodb_write_io_threads = "3"
    $__innodb_read_io_threads = "3"
    $__innodb_io_capacity = "2000"
    $__innodb_flush_neighbor_pages = "0"
    $__innodb_lock_wait_timeout = "100"
    $__innodb_max_dirty_pages_pct = "75"
    $__innodb_read_ahead = "linear"

   #just a base config.
   $__mysql_config = $__db_store ? {
       myisam => template("mysql/my5-server-base.cnf.erb", "mysql/my5-server-myisam.cnf.erb" ),
       innodb => template("mysql/my5-server-base.cnf.erb", "mysql/my5-server-innodb.cnf.erb" ),
       xtradb => template("mysql/my5-server-base.cnf.erb", "mysql/my5-server-innodb.cnf.erb", "mysql/my5-server-xtradb.cnf.erb" ),
       both => template("mysql/my5-server-base.cnf.erb", "mysql/my5-server-both.cnf.erb" )
   }

   file { "/etc/mysql/my5-server.cnf":
        content => $__mysql_config
   }
}
