
Introduction
============

Follow these steps to run a kitsune development environment inside a virtual machine.

Installation
============

Clone the repository::

    $ gem install vagrant
    $ git clone git://github.com/readevalprint/kitsune-vagrant.git
    $ cd kitsune-vagrant

Then up the vagrant box::

    $ vagrant up

This will take about 15-20 minutes to run on a "modern" machine (author has 2.66Ghz Macbook Pro w/4GB RAM). When it finishes, you will be able to connect to the vagrant box::

    $ vagrant ssh

From within the vagrant shell::

    $ cd kitsune
    $ python ./manage.py runserver


Then in your browser open::

- http://33.33.33.10:8000

When you are finished working, in the host type::

    $ vagrant halt


Troubleshooting
===============

Vagrant is taking too long
--------------------------

Sometimes ``vagrant up`` will say::

    [default] Waiting for VM to boot. This can take a few minutes.

then take much longer. If it takes longer than a few minutes, CTRL-C and re-run ``vagrant up``.

Vagrant says read-only fs
-------------------------

Sometimes ``vagrant up`` will quit with the message::

    [default] err: Could not send report: Got 1 failure(s) while initializing: change from absent to directory failed: Could not set 'directory on ensure: Read-only file system - /var/lib/puppet/rrd

``vagrant destroy`` and ``vagrant up`` again should fix the problem (whatever it is).

Vagrant won't gem install, with a vague datetime error
------------------------------------------------------

Use the most current version of rubygems, and not the one from your distibution.
http://rubyforge.org/projects/rubygems/

Notes
=====

.. [1] https://github.com/jsocol/kitsune
.. [2] Requires vagrant and VirtualBox to be installed: http://vagrantup.com, http://www.virtualbox.org/.
.. _`Firefox`: http://getfirefox.com
.. [3] You only need to do this once. Afterward you can ``vagrant destroy`` and ``vagrant up`` as needed.

