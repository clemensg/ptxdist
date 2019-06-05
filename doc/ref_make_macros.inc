.. _reference_macros:

Rule File Macro Reference
-------------------------

Rules files in PTXdist are using macros to get things work. Its highly
recommended to use these macros instead of doing something by ourself. Using these
macros is portable and such easier to maintain in the case a project should be
upgraded to a more recent PTXdist version.

This chapter describes the predefined macros in PTXdist and their usage.

Whenever one of these macros installs something to the target's root filesystem,
it also accepts user and group IDs which are common in all filesystems Linux
supports. These IDs can be given as numerical values and as text strings.
In the case text strings are given PTXdist converts them into the
corresponding numerical value based on the BSP local files :file:`passwd` and :file:`group`.
If more than one file with these names are present in the BSP PTXdist follows
its regular rules which one it prefers.

Many paths shown here contains some parts in angle brackets. These have
special meanings in this document.

**<platform>**
  The name of a platform. Corresponds to the variable
  ``PTXCONF_PLATFORM``
**<platform-src>**
  The directory where the platform is defined. Corresponds to the variable
  ``PTXDIST_PLATFORMCONFIGDIR``
**<platform-dir>**
  Concatenated directory name with a leading *platform-* and the name of the
  selected platform name, e.g. <platform>. If the name of the currently active
  platform is *foo*, the final directory name is *platform-foo*.
  Corresponds to the variable ``PTXDIST_PLATFORMDIR``

.. note:: The list of supported macros is not complete yet.

targetinfo
~~~~~~~~~~

Usage:

.. code-block:: make

 $(call targetinfo)

Gives a feedback, what build *stage* is just started. That's why it
should always be the first call for each *stage*. For the package
*foo* and the *compile stage* it will output:

.. code-block:: bash

 --------------------
 target: foo.compile
 --------------------

touch
~~~~~~

Usage:

.. code-block:: make

 $(call touch)

Gives a feedback, what build *stage* is just finished. That's why it
should always be the last call for each *stage*. For the package
*foo* and the *compile stage* it will output:

.. code-block:: bash

 finished target foo.compile

clean
~~~~~

Usage:

.. code-block:: make

 $(call clean, <directory path>)

Removes the given directory ``<directory path>``

.. _install_copy:

world/get, world/extract, world/prepare, world/compile, world/install
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call world/get, <PKG>)

The same for all other macros. These are the default build commands for the
corresponding stages. For more details see the documentation of the default
stages below.

extract
~~~~~~~

Usage:

.. code-block:: make

 $(call extract, <PKG>)

Extract a source archive into a directory.
The source archive to unpack is taken from the ``<PKG>_SOURCE`` variable,
and the directory to unpack to is taken from the ``<PKG>_DIR`` variable.
This macro doesn't do anything if ``<PKG>_URL`` points to a local directory
instead of an archive or online URL.

compile
~~~~~~~

Usage:

.. code-block:: make

 $(call compile, <PKG>, <build arguments>)

This macro is very similar to ``world/compile``. The only differences is
that is uses the specified ``build arguments`` instead of
``<PKG>_MAKE_OPT``. This is usefull if ``make`` needs to be called more
than once in the compile stage.

world/execute, execute
~~~~~~~~~~~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call execute, <PKG>, <command with arguments>)
 $(call world/execute, <PKG>, <command with arguments>)

These macros make it possible to execute arbitrary commands during the
build stages. This is usefull because the environment is identical to the
default build commands ``world/*``.

``world/execute`` also handles the generic setup handled in the current
build stage. For ``prepare`` this means that, for out ot tree builds, the
build directory is deleted prior to executing the specified command.
For ``install`` the package directory is deleted.

When ``--verbose`` is used then the full command is logged. With
``--quiet`` both stdout and stderr are redirected to the logfile.

.. _install_copy,reference:

install_copy
~~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_copy, <package>, <UID>, <GID>, <permission>, <source> [, <dest> [, <strip> ]])

Installs given file or directory into:

* the project's ``<platform-dir>/root/``
* an ipkg/opkg packet in the project's ``<platform-dir>/packages/``

Some of the parameters have fixed meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<UID>**
  User ID the file should use in the target's root filesystem
**<GID>**
  Group ID the file should use in the target's root filesystem
**<permission>**
  Permission (in an octal value) the file should use in the target's root filesystem

The remaining parameters vary with the use case:

The ``<source>`` parameter can be:

* a directory path that should be created in the target's root filesystem.
  In this case the <destination> must be omitted.
  The given path must always start with a ``/`` and means the root
  of the target's filesystem.
* an absolute path to a file that should be copied to the target's root
  filesystem. To avoid fixed paths, all packages are providing the
  <PKG>_DIR variable. So, this parameter in our
  *foo* example package can be a ``$(FOO_DIR)/foo``.
* a minus sign (``-``). PTXdist uses the <destination>
  parameter in this case to locate the file to copy from. 
  The <destination> is uses a path relative to the :ref:`package install
  directory<pkg_pkgdir>`. This only works if the package uses the default
  or a similar *install* stage. For our *foo* example used source file is
  ``<platform-dir>/packages/foo-1.1.0/<destination>``.

The ``<dest>`` parameter can be:

* omitted if a directory in target's root filesystem should be created.
  For this case the directory to be created is in the <source> parameter.
* an absolute path and filename with its root in target's root filesystem.
  It must start with a slash (``//``). If also the <source>
  parameter was given, the file can be renamed while copying.
  If the <source> parameter was given as a minus
  sign (``-``) the <destination> is also used to
  locate the source. For our *foo* example package if we give
  <destination> as ``/usr/bin/foo``, PTXdist
  copies the file ``<platform-dir>/packages/foo-1.1.0/usr/bin/foo``

The ``<strip>`` is a complete optional parameter to prevent
this macro from the regular stripping process it does on files. Most of the cases
stripping debug information from files is intended. But some kind of files getting
destroyed when this stripping happens to them. One example is a Linux kernel module.
If it gets stripped, it can't be loaded into the kernel anymore.

**full strip**
  fully strip the file while installing when this parameter is **y** or not
  given at all (default case).
**partially strip**
  only strips real debug information from the file when this parameter is
  **k**. Useful to keep Linux kernel module loadable at run-time
**no strip**
  preserve the file from being stripped when this parameter is one of the
  following: **0**, **n**, **no**, **N** or **NO**.

Due to the complexity of this macro, here are some usage examples:

Create a directory in the root filesystem:

.. code-block:: make

 $(call install_copy, foo, 0, 0, 0755, /home/user-foo)

Copy a file from the package build directory to the root filesystem:

.. code-block:: make

 $(call install_copy, foo, 0, 0, 0755, $(FOO_DIR)/foo, /usr/bin/foo)

Copy a file from the package build directory to the root filesystem and rename
it:

.. code-block:: make

 $(call install_copy, foo, 0, 0, 0755, $(FOO_DIR)/foo, /usr/bin/bar)

Copy a file from the package install directory to the root filesystem:

.. code-block:: make

 $(call install_copy, foo, 0, 0, 0755, -, /usr/bin/foo)

.. _install_tree,reference:

install_tree
~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_tree, <package>, <UID>, <GID>, <source dir>, <destination dir>, <strip>])

Installs the whole directory tree with all files from the given directory into:

* the project's ``<platform-dir>/root/``
* an ipkg packet in the project's ``<platform-dir>/packages/``

Some of the parameters have fixed meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<UID>**
  User ID the directories and files should use in the target's root filesystem
  or ``-`` to keep the UID from the source tree
**<GID>**
  Group ID the directories and files should use in the target's root filesystem
  or ``-`` to keep the GID from the source tree
**<source dir>**
  This is the path to the tree of directories and files to be installed. It can
  be ``-`` to use the package directory of the current package instead
**<destination dir>**
  The basename of the to-be-installed tree in the root filesystem
**<strip>**
  same as for :ref:`install_copy,reference`.

Note: This installation macro

* uses the same permission flags in the destination dir as found
  in the source dir. This is valid for directories and regular files
* skips all directories with names like ``.svn``, ``.git``, ``.pc`` and
  ``CVS`` in the source directory

Examples:

Install the whole tree found in ``/home/jbe/foo`` to the root filesystem
at location ``/usr/share/bar``.

.. code-block:: make

 $(call install_tree, foo, 0, 0, /home/jbe/foo, /usr/share/bar)

Install all files from the tree found in the current package FOO to the root
filesystem at location ``/usr/share/bar``.

.. code-block:: make

 $(call install_tree, foo, 0, 0, -, /usr/share/bar)

If the current package is ``foo-1.0`` the base path for the directory tree
will be ``$(PKGDIR)/foo-1.0/usr/share/bar``.

install_alternative_tree
~~~~~~~~~~~~~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_alternative_tree, <package>, <UID>, <GID>, <destination dir>)

Installs the whole source directory tree with all files from the given directory into:

* the project's ``<platform-dir>/root/``
* an ipkg packet in the project's ``<platform-dir>/packages/``

The ``<destination dir>`` is used like in the ``install_alternative`` to let
PTXdist search in the same directories and order for the given directory.

Some of the parameters have fixed meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<UID>**
  User ID the directories and files should use in the target's root filesystem
  or ``-`` to keep the UID from the source
**<GID>**
  Group ID the directories and files should use in the target's root
  filesystem or ``-`` to keep the GID from the source
**<destination dir>**
  The basename of the to-be-installed tree in the root filesystem

.. note:: This installation macro

  * uses the same permission flags in the destination dir as found in the source
    dir. This is valid for directories and regular files
  * skips all directories with names like ``.svn``, ``.git``, ``.pc`` and ``CVS``
    in the source directory

Examples:

Install the whole tree found in project's ``projectroot/usr/share/bar``
to the root filesystem at location ``/usr/share/bar``.

.. code-block:: make

 $(call install_alternative_tree, foo, 0, 0, /usr/share/bar)

To install nothing, use a symlink to ``/dev/null`` instead of the base
directory. See :ref:`install_alternative` for more details.

.. _install_alternative:

install_alternative
~~~~~~~~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_alternative, <package>, <UID>, <GID>, <permission>, <destination>)

Installs given files or directories into:

* the project's ``<platform-dir>/root/``
* an ipkg/opkg packet in the project's ``<platform-dir>/packages/``

The base parameters and their meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<UID>**
  User ID the file should use in the target's root filesystem
**<GID>**
  Group ID the file should use in the target's root filesystem
**<permission>**
  Permission (in an octal value) the file should use in the target's root filesystem

The parameter <destination> is meant as an absolute path
and filename in target's root filesystem. PTXdist searches for the source
of this file in:

* the local project
* in the used platform
* PTXdist's install path
* in the current package

As this search algorithm is complex, here an example for the file
``/etc/foo`` in package ``FOO``. PTXdist will search for this
file in the following order:

* project's directory ``projectroot.<platform>/etc/foo``
* project's directory ``projectroot/etc/foo.<platform>``
* platform's directory ``<platform-src>/projectroot/etc/foo.<platform>``
* project's directory ``projectroot/etc/foo``
* platform's directory ``<platform-src>/projectroot/etc/foo``
* ptxdist's directory ``projectroot/etc/foo``
* package's directory ``$(FOO_PKGDIR)/etc/foo``
* package's directory ``$(FOO_DIR)/etc/foo``

The generic rules are looking like the following:

* ``$(PTXDIST_WORKSPACE)/projectroot$(PTXDIST_PLATFORMSUFFIX)/etc/foo``
* ``$(PTXDIST_WORKSPACE)/projectroot/etc/foo$(PTXDIST_PLATFORMSUFFIX)``
* ``$(PTXDIST_PLATFORMCONFIGDIR)/projectroot/etc/foo$(PTXDIST_PLATFORMSUFFIX)``
* ``$(PTXDIST_WORKSPACE)/projectroot/etc/foo``
* ``$(PTXDIST_PLATFORMCONFIGDIR)/projectroot/etc/foo``
* ``$(PTXDIST_TOPDIR)/projectroot/etc/foo``
* ``$(FOO_PKGDIR)/etc/foo``
* ``$(FOO_DIR)/etc/foo``

Note: You can get the current values for the listed variables above via running
PTXdist with the ``print`` parameter:

.. code-block:: bash

 $ ptxdist print PTXDIST_PLATFORMSUFFIX

``install_alternative`` is used by upstream PTXdist packages to install
config files. In some rare use-cases the file should not be installed at
all. For example if the config file is generated at runtime or provided by
a special configuration package. This is possible by creating a symlink to
``/dev/null`` instead of a file at one of the locations described above.
PTXdist skips installing the file if it detects such a symlink.

install_link
~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_link, <package>, <point to>, <where>)

Installs a symbolic link into:

* the project's ``<platform-dir>/root/``
* an ipkg/opkg packet in the project's ``<platform-dir>/packages/``

The parameters and their meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<point to>**
  Path and name the link should point to. Note: This macro rejects absolute
  paths. If needed use relative paths instead.
**<where>**
  Path and name of the symbolic link.

A few usage examples.

Create a symbolic link as ``/usr/lib/libfoo.so`` pointing to
``libfoo.so.1.1.0`` in the same directory:

.. code-block:: make

 $(call install_link, foo, libfoo.so.1.1.0, /usr/lib/libfoo.so)

Create a symbolic link as ``/usr/bin/foo`` pointing to ``/bin/bar``:

.. code-block:: make

 $(call install_link, foo, ../../bin/bar, /usr/bin/foo)

.. _install_archive:

install_archive
~~~~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_archive, <package>, <UID>, <GID>, <archive> , <base path>)

Installs archives content into:

* the project's ``<platform-dir>/root/``
* an ipkg/opkg packet in the project's ``<platform-dir>/packages/``

All parameters have fixed meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<UID>**
  User ID all files and directory of the archive should use in the target's
  root filesystem. A ``-`` uses the file's/directory's UID in the archive
**<GID>**
  Group ID the files and directories should use in the target's root filesystem.
  A ``-`` uses the file's/directory's GID in the archive
**<archive>**
  Name of the archive to be used in this call. The given path and filename is
  used as is
**<base path>**
  Base path component in the root filesystem the archive should be extracted
  to. Can be just ``/`` for root.

install_glob
~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_glob, <package>, <UID>, <GID>, <source dir>, <destination dir>, <yglob>, <nglob>[, <strip>])

Installs parts of a directory tree with all files from the given directory
into:

* the project's ``<platform-dir>/root/``
* an ipkg packet in the project's ``<platform-dir>/packages/``

Some of the parameters have fixed meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<UID>**
  User ID the directories and files should use in the target's root filesystem
  or ``-`` to keep the UID from the source tree
**<GID>**
  Group ID the directories and files should use in the target's root filesystem
  or ``-`` to keep the GID from the source tree
**<source dir>**
  This is the path to the tree of directories and files to be installed. It can
  be ``-`` to use the package directory of the current package instead
**<destination dir>**
  The basename of the to-be-installed tree in the root filesystem
**<yglob>**
  A list of pathname patterns. All files or directories that match _any_
  pattern in the list are installed. Note: the patterns must match the
  whole absolute path, e.g. ``*/foo``. An empty list is equivalent to a
  pattern that matches all files.
**<nglob>**
  Like ``<yglob>`` but any matching files or directories will not be
  installed. For directories, this includes the whole contents of the
  directory.

Except for the pathname patterns, this command works like ``install_tree``.
The ``<yglob>`` and ``<nglob>`` patterns are combined: Only files that
match ``<yglob>`` and do not match ``<nglob>`` are installed.

Examples:

Install all shared libraries found in ``$(FOO_PKGDIR)/usr/lib/foo`` except
libbar.so

.. code-block:: make

 $(call install_glob, foo, 0, 0, -, /usr/lib/foo, *.so, */libbar.so)

install_lib
~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_lib, <package>, <UID>, <GID>, <permission>, <libname>)

Installs the shared library <libname> into the root filesystem.

* the project's ``<platform-dir>/root/``
* an ipkg/opkg packet in the project's ``<platform-dir>/packages/``

The parameters and their meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<UID>**
  User ID the file should use in the target's root filesystem
**<GID>**
  Group ID the directories and files should use in the target's root filesystem
**<permission>**
  Permission (as an octal value) the library should use in the target's root
  filesystem (mostly 0644)
**<libname>**
  Basename of the library without any extension and path

The ``install_lib`` macro searches for the library at the most
common directories ``/lib`` and ``/usr/lib``. And it searches always
in the package's corresponding directory in ``<platform-dir>/packages/``.
It also handles all required links to make the library work at run-time.

An example.

Lets assume the package 'foo-1.0.0' has installed the library ``libfoo`` into
its ``<platform-dir>/packages/foo-1.0.0`` at:

* the lib: ``<platform-dir>/packages/foo-1.0.0/usr/lib/libfoo1.so.0.0.0``
* first link: ``<platform-dir>/packages/foo-1.0.0/usr/lib/libfoo1.so.0``
* second link: ``<platform-dir>/packages/foo-1.0.0/usr/lib/libfoo1.so``

.. note:: The second link is only needed  for the linker at build-time to
   resolve ``-lfoo1``. It is not needed at run-time so ``install_lib`` will
   skip it.

To install this library and its corresponding link, the following line does the job:

.. code-block:: make

 $(call install_lib, foo, 0, 0, 0644, libfoo1)

Note: The package's install stage must be 'DESTDIR' aware to be able to make
it install its content into the corresponding packages directory (in our example
``<platform-dir>/packages/foo-1.0.0/`` here).

install_replace
~~~~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call install_replace, <package>, <filename>, <placeholder>, <value>)

Replace placeholder with value in a previously installed file.

The parameters and their meanings:

**<package>**
  Name of the IPKG/OPKG the macro should work on
**<filename>**
  Absolute filepath in target root filesystem
**<placeholder>**
  A string in the file which should be replaced. Usually some uppercase word
  surrounded by @ signs
**<value>**
  The value which should appear in the root filesystem instead of the
  placeholder, could be some PTXCONF variable

The ``install_replace`` macro can be used in targetinstall stage to adapt
some template and replace strings with content from menu variables or other
sources. For example look at the timezone you set in the ptxdist menu. An
``install_replace`` call in ``rules/timezone.make`` replaces the string
``@TIMEZONE@`` in the file ``/etc/timezone`` in root filesystem with the
content of the menu variable ``PTXCONF_TIMEZONE_LOCALTIME``. The file must
be installed with some other ``install_*`` command before
``install_replace`` can be used. A typical call would look like this:

.. code-block:: make

   $(STATEDIR)/timezone.targetinstall:
        ...
   	@$(call install_replace, timezone, /etc/timezone, @TIMEZONE@, \
   		$(PTXCONF_TIMEZONE_LOCALTIME))

.. _param_macros:
.. _ptxEndis:
.. _ptxDisen:
.. _ptx_wwo:
.. _ptx_ifdef:
.. _ptx_truefalse:

ptx/endis, ptx/disen, ptx/wwo, ptx/truefalse, ptx/ifdef
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Usage:

.. code-block:: make

 $(call ptx/endis, VARIABLE)
 $(call ptx/disen, VARIABLE)
 $(call ptx/wwo, VARIABLE)
 $(call ptx/truefalse, VARIABLE)
 $(call ptx/ifdef, VARIABLE, [expansion-if-true], [expansion-if-false])

Several macros exist to convert the state (set/unset) of a variable into a string.
These are useful for ``<PKG>_CONF_OPT`` variables, and expand as follows:

+--------------------+-------------------------------+---------------------------------+---------------------+
| Macro name         | Expansion if ``VARIABLE`` set | Expansion if ``VARIABLE`` unset | Exemplary use case  |
+====================+===============================+=================================+=====================+
| ptx/endis          | ``enable``                    | ``disable``                     | autoconf            |
+--------------------+-------------------------------+---------------------------------+---------------------+
| ptx/disen          | ``disable``                   | ``enable``                      | autoconf            |
+--------------------+-------------------------------+---------------------------------+---------------------+
| ptx/wwo            | ``with``                      | ``without``                     | autoconf            |
+--------------------+-------------------------------+---------------------------------+---------------------+
| ptx/yesno          | ``yes``                       | ``no``                          | autoconf cache vars |
+--------------------+-------------------------------+---------------------------------+---------------------+
| ptx/truefalse      | ``true``                      | ``false``                       | meson               |
+--------------------+-------------------------------+---------------------------------+---------------------+
| ptx/falsetrue      | ``false``                     | ``true``                        | meson               |
+--------------------+-------------------------------+---------------------------------+---------------------+
| ptx/onoff          | ``ON``                        | ``OFF``                         | cmake               |
+--------------------+-------------------------------+---------------------------------+---------------------+
| ptx/ifdef          | *the second parameter*        | *the third parameter*           | *(multiple)*        |
+--------------------+-------------------------------+---------------------------------+---------------------+

Some real-life examples:

.. code-block:: make
 :linenos:

 BASH_CONF_OPT      += --$(call ptx/endis, PTXCONF_BASH_DEBUGGER)-debugger
 OPENOCD_CONF_OPT   += --$(call ptx/disen, PTXCONF_OPENOCD_PARPORT_DISABLE_PARPORT_PPDEV)-parport-ppdev
 COREUTILS_CONF_OPT += --$(call ptx/wwo, PTXCONF_GLOBAL_SELINUX)-selinux
 LESS_CONF_ENV      += ac_cv_lib_ncurses_initscr=$(call ptx/yesno, PTXCONF_LESS_NCURSES)

 SYSTEMD_CONF_OPT   += -Dmicrohttpd=$(call ptx/truefalse,PTXCONF_SYSTEMD_MICROHTTPD)
 SYSTEMD_CONF_OPT   += -Drandomseed=$(call ptx/falsetrue,PTXCONF_SYSTEMD_DISABLE_RANDOM_SEED)

 MYSQL_CONF_OPT     += -DWITH_SYSTEMD=$(call ptx/onoff, PTXCONF_MYSQL_SYSTEMD)

 CUPS_CONF_OPT      += $(call ptx/ifdef,PTXCONF_CUPS_PERL,--with-perl=/usr/bin/perl,--without-perl)

If the respective variable is set, these statements would expand to:

.. code-block:: make
 :linenos:

 BASH_CONF_OPT      += --enable-debugger
 OPENOCD_CONF_OPT   += --disable-parport-ppdev
 COREUTILS_CONF_OPT += --with-selinux
 LESS_CONF_ENV      += ac_cv_lib_ncurses_initscr=yes

 SYSTEMD_CONF_OPT   += -Dmicrohttpd=true
 SYSTEMD_CONF_OPT   += -Drandomseed=false

 MYSQL_CONF_OPT     += -DWITH_SYSTEMD=on

 CUPS_CONF_OPT      += --with-perl=/usr/bin/perl

whereas if the respective variable is unset, they would expand to the opposite:

.. code-block:: make
 :linenos:

 BASH_CONF_OPT      += --disable-debugger
 OPENOCD_CONF_OPT   += --enable-parport-ppdev
 COREUTILS_CONF_OPT += --without-selinux
 LESS_CONF_ENV      += ac_cv_lib_ncurses_initscr=no

 SYSTEMD_CONF_OPT   += -Dmicrohttpd=false
 SYSTEMD_CONF_OPT   += -Drandomseed=true

 MYSQL_CONF_OPT     += -DWITH_SYSTEMD=off

 CUPS_CONF_OPT      += --without-perl

ptx/get-alternative
~~~~~~~~~~~~~~~~~~~

This macro can be used to find files or directories in the BSP and PTXdist.
There are two arguments, **prefix** and **file**. The search path is very
similar to :ref:`install_alternative`. The first existing location of the
following paths is returned:

* ``$(PTXDIST_WORKSPACE)/$(prefix)$(PTXDIST_PLATFORMSUFFIX)/$(file)``
* ``$(PTXDIST_WORKSPACE)/$(prefix)/$(file)$(PTXDIST_PLATFORMSUFFIX)``
* ``$(PTXDIST_PLATFORMCONFIGDIR)/$(prefix)/$(file)$(PTXDIST_PLATFORMSUFFIX)``
* ``$(PTXDIST_WORKSPACE)/$(prefix)/$(file)``
* ``$(PTXDIST_PLATFORMCONFIGDIR)/$(prefix)/$(file)``
* ``$(PTXDIST_TOPDIR)/$(prefix)/$(file)``


.. _in_path:

ptx/in-path
~~~~~~~~~~~

This macro can be used to find files or directories in the BSP and PTXdist.
There are two arguments, **path variable** and **file**. The **path
variable** must be a variable name that is available in a shell called by
**make**. The variable must contain a ``:`` separated list of directories.
The **file** will be searched in these directories and the first existing
path is returned. PTXdist defines several variables that can be used here.
The directories are in the usual search order.

-  **PTXDIST_PATH_LAYERS** contains all layers from **PTXDIST_WORKSPACE**
   to **PTXDIST_TOPDIR**

- **PTXDIST_PATH** is like **PTXDIST_PATH_LAYERS** but also contains the
  **PTXDIST_PLATFORMCONFIGDIR** for each layer.

- **PTXDIST_PATH_SCRIPTS**, **PTXDIST_PATH_RULES** and
  **PTXDIST_PATH_PLATFORMS** are like **PTXDIST_PATH** with the extra
  ``scripts/``, ``rules/`` and ``platforms/`` subdirectory respectively.

Hint: use the :ref:`print<command_print>` command to get the exact list of
directories for each of these variables.

.. _in_platformconfigdir:

ptx/in-platformconfigdir
~~~~~~~~~~~~~~~~~~~~~~~~

This macro is only useful with multiple layers. It has one argument
**file**. The **file** is searched for in the platform directory in
all layers in the usual search order. It returns the first existing file.
If none exists it returns ``$(PTXDIST_PLATFORMCONFIGDIR)/$(file)``. This
avoids unexpected errors due to empty variables if a file is missing.
