redshift
--------

Since redshift 1.12-3 in Debian apparmor is used for redshift and prevents opening the config file, because it is a symlink.

You should add the following in `/etc/apparmor.d/local/usr.bin.redshift`:

    ../.homesick/repos/awesome-config/home/.config/redshift.conf
