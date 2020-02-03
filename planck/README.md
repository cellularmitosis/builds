# Using these tarballs

```
version=2.24.0
cd /opt
cat planck-$version-buster-i386.tar.gz | gunzip | tar x
ln -sf /opt/planck-$version/bin/planck /usr/local/bin/
ln -sf /opt/planck-$version/bin/plk /usr/local/bin/
ln -sf /opt/planck-$version/share/man/man1/planck.1 /usr/local/share/man/man1/
ln -sf /opt/planck-$version/share/man/man1/plk.1 /usr/local/share/man/man1/
apt-get install -y libjavascriptcoregtk-4.0 libglib2.0 libzip4 libcurl4 libicu63
```
