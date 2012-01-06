group { "puppet":
    ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
    content => "Welcome to your Vagrant-built virtual machine!
                Managed by Puppet. Featuring kitsune.\n"
}

file { '/home/vagrant/kitsune/settings_local.py':
    content => "from settings import *\n
DATABASES = {
    'default': {
        'NAME': 'kitsune',
        'ENGINE': 'django.db.backends.mysql',
        'HOST': 'localhost',
        'USER': 'root',
        'PASSWORD': '',
        'OPTIONS': {'init_command': 'SET storage_engine=InnoDB'},
        'TEST_CHARSET': 'utf8',
        'TEST_COLLATION': 'utf8_unicode_ci',
    },
}\n",
    require => Exec['git_clone'],
}

file { '/home/vagrant/.bash_profile':
    content => 'PS1="\[\e[32m\][\u@\h]\[\e[0m\]\[\e[37m\][\t]\[\e[0m\]\n\[\e[36m\][\w]\[\e[0m\]>"'
}

$packages_native = [
    "git-core",
    "libmysqlclient-dev",
    "libxml2-dev",
    "libxslt-dev",
    "mysql-server",
    "python-pip",
    "python2.6",
    "python2.6-dev",
    "python-distribute",
    "sphinxsearch",
    "supervisor",
    "dkms",
    "vim",
    "ack-grep",
    "virtualbox-ose-guest-utils",
]

package {
    $packages_native: ensure => "installed",
    require => Exec['packages_update'],
}

exec { "packages_update":
    command => "aptitude update",
    logoutput => "true",
    path => "/usr/bin",
}


exec { "git_clone":
    command => "git clone git://github.com/mozilla/kitsune.git || echo $?",
    path => "/bin:/sbiny:/usr/bin:/usr/local/sbin:/usr/sbin",
    cwd => "/home/vagrant",
    logoutput => "true",
    require => Package[$packages_native],
    timeout => "-1",
}

exec { "chown_kitsune":
    command => "sudo chown -R vagrant:vagrant /home/vagrant/kitsune",
    logoutput => "true",
    path => "/usr/bin",
    require => Exec['git_clone'],
}

exec { "packages_compiled":
    command => "sudo pip install -r requirements/compiled.txt",
    cwd => "/home/vagrant/kitsune",
    path => "/usr/bin",
    require => Exec['chown_kitsune'],
}

exec { "packages_vendor":
    command => "git submodule update --init",
    cwd => "/home/vagrant/kitsune",
    path => "/usr/bin:/bin",
    logoutput => true,
    require => Exec[
        'packages_compiled',
        'chown_kitsune',
        'git_clone'
    ],
    timeout => "6000",
}

exec { "db_create":
    command => "mysqladmin -u root create kitsune || echo $?",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => Exec['packages_vendor'],
}

exec { "db_import":
    command => "mysql -u root kitsune < scripts/schema.sql || echo $?",
    cwd => "/home/vagrant/kitsune",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => Exec['db_create'],
}

exec { "sql_migrate":
    command => "python /home/vagrant/kitsune/vendor/src/schematic/schematic /home/vagrant/kitsune/migrations/",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => Exec["db_import"],
}

