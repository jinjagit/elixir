from: https://blog.differentpla.net/blog/2019/01/30/erlang-build-prerequisites/

If you want to use kerl to build your Erlang installation, you’re going to need some packages installed first.

For Ubuntu, the list (taken from here) is as follows:
Required

sudo apt-get -y install build-essential     # assumed

### These will result in the build failing if they're not present.
sudo apt-get -y install autoconf m4         # ./otp_build: autoconf: not found
sudo apt-get -y install libssl-dev          # No usable OpenSSL found
sudo apt-get -y install libncurses5-dev     # configure: error: No curses library functions found

Recommended

### I'd consider this one "essential", because you need it to make observer work.
sudo apt-get -y install libwxgtk3.0-dev     # wxWidgets not found, wx will NOT be usable

This list is correct for Erlang/OTP-21.3 and Ubuntu 18.04. The following may not be, because I never bother installing them.
Optional

### I consider these "optional", because I've never noticed them missing.
sudo apt-get -y install default-jdk         # jinterface     : No Java compiler found
sudo apt-get -y install unixodbc-dev        # odbc           : ODBC library - link check failed

### These are for the documentation.
sudo apt-get -y install xsltproc fop libxml2-utils


### MY NOTES:
Note the 2 dependencies - java interpreter & wx widgets... absence of these will throw warnings during erlang compile (but not prevent compilation)

Don't forget to install using asdf version manager:
https://thinkingelixir.com/install-elixir-using-asdf/#Install_your_Elixir_version
https://gist.github.com/rubencaro/6a28138a40e629b06470
