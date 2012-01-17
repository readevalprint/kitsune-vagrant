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
    content => 'PS1="\[\e[32m\][\u@\h]\[\e[0m\]\[\e[37m\][\t]\[\e[0m\]\n\[\e[36m\][\w]\[\e[0m\]>"\n
alias ack=\"ack-grep\"
alias ll="ls -l"
alias la="ls -A"
alias l="ls -CF"'
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


