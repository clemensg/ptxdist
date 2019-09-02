Variables Reference
-------------------

The following variables are provided by PTXdist to simplify creating
rule files. Every developer should use these variables in every single
line in the **rule file** to avoid any further adaption when external paths
are changed.

To get their content related to the current project, we can simply run
a:

::

    $ ptxdist print PTXDIST_TOPDIR
    /usr/local/lib/ptxdist-|ptxdistVendorVersion|

Replace the ``PTXDIST_TOPDIR`` with one of the other generic variables
PTXdist provides.

Global Variables
~~~~~~~~~~~~~~~~

``PTXDIST_TOPDIR``
  Points always to the installation directory of PTXdist.

.. _ptxdist_workspace:

``PTXDIST_WORKSPACE``
  Everything that references ``PTXDIST_WORKSPACE`` will use the active
  projects’s folder.

``PTXDIST_SYSROOT_CROSS``
  ``PTXDIST_SYSROOT_CROSS`` points to a directory tree all cross relevant
  executables, libraries and header files are installed to in the current
  project. All of the project’s packages built for the host to create data
  for the target are searching in this directory tree for their
  dependencies (executables, header and library files). Use
  ``$(PTXDIST_SYSROOT_CROSS)/bin`` to install executables,
  ``$(PTXDIST_SYSROOT_CROSS)/include`` for header files and
  ``$(PTXDIST_SYSROOT_CROSS)/lib`` for libraries.

``PTXDIST_SYSROOT_HOST``
  ``PTXDIST_SYSROOT_HOST`` points to a directory tree all host relevant
  executables, libraries and header files are installed to. All project’s
  packages built for the host are searching in this directory tree for
  their dependencies (executables, header and library files). Use
  ``$(PTXDIST_SYSROOT_HOST)/bin`` to install executables,
  ``$(PTXDIST_SYSROOT_HOST)/include`` for header files and
  ``$(PTXDIST_SYSROOT_HOST)/lib`` for libraries.

``PTXDIST_SYSROOT_TARGET``
  ``PTXDIST_SYSROOT_TARGET`` points to a directory tree all target
  relevant libraries and header files are installed to. All project’s
  packages built for the target are searching in this directory tree for
  their dependencies (header and library files). These files are for
  compile time only (for example to link a target executable against a
  target library), not for run-time! Use
  ``$(PTXDIST_SYSROOT_TARGET)/include`` for header files and
  ``$(PTXDIST_SYSROOT_TARGET)/lib`` for libraries.

Other useful variables:

``CROSS_PATH``
  Use to find cross tools. This path must be used to create anything that
  depends on the target’s architecture, but needs something running on the
  host to do the job. Examples:

  **Creating a UBI image from the target’s root filesystem**
      This will need a tool running on the host, but it will create data
      or code that runs on or is used on the target

  **Building a library for the target**
      If this library needs other resources to be built (other libraries)
      its ``configure`` finds the right information in this path.

``HOST_PATH``
  Used to find host tools. This path must be used to create anything that
  doesn't depend on the architecture.

``ROOTDIR``
  ``ROOTDIR`` points to the root of the target’s root filesystem in the
  current project. Used in very rare cases (to create strange packages
  based on data in target’s root filesystem for example).

``PTXCONF_PLATFORM``
  ``PTXCONF_PLATFORM`` expands to the name of the currently selected
  platform. This name is used in various file names and paths.

``PTXDIST_PLATFORMSUFFIX``
  ``PTXDIST_PLATFORMSUFFIX`` expands to the name of the currently selected
  platform, but with a leading dot. This is used in various files PTXdist
  should search for.

.. _ptxdist_platformconfigdir:

``PTXDIST_PLATFORMCONFIGDIR``
  ``PTXDIST_PLATFORMCONFIGDIR`` points to the directory tree of the
  currently selected platform. This path is used in various search
  functions.

``PTXDIST_PLATFORMDIR``
  ``PTXDIST_PLATFORMDIR`` points to the directory build tree of the
  currently selected platform.

``PACKAGES``, ``PACKAGES-y``, ``PACKAGES-m``
  ``PACKAGES`` is a list of space-separated lowercase package names that are
  built and installed during the PTXdist build run, and installed into the
  target root filesystem when building images.

  The ``-y`` variant contains only those packages that are selected with
  ``PTXCONF_<PKG>=y``, while the ``-m`` variant contains only those which are
  selected with ``PTXCONF_<PKG>=m`` (used for collections).
  A target package rule usually adds its name to one of those variables if it
  has been selected.
  The union of those two sets then ends up in ``PACKAGES``.

``EXTRA_PACKAGES``, ``EXTRA_PACKAGES-y``, ``EXTRA_PACKAGES-m``
  In analogy to ``PACKAGES``, target packages that are added to these lists will
  be built normally during the build run.
  In contrast however, they are not installed into a root filesystem by default
  when building images, and image rules must request them explicitely.
  This is useful for specialized packages that are only needed for specific
  images, see :ref:`multi_image_individual_root_filesystems`.

``HOST_PACKAGES``, ``CROSS_PACKAGES``
  Similar to ``PACKAGES``, these variables contain the host and cross packages
  that are built and installed during the PTXdist build run.
  There are analogous ``-y`` and ``-m`` variants of those variables too.

Package Specific Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~

For the following variables ``<PKG>`` is a placeholder for the package
name. It is also the Kconfig symbol name (without the ``PTXCONF_`` prefix).

Package Definition
^^^^^^^^^^^^^^^^^^

``<PKG>``
  This is the name of the package including version. For most packages,
  this is the name of the source archive (without suffix) and the source
  directory. PTXdist will search for patches in a directory with this name.
  This is usually defined as ``<name>-$(<PKG>_VERSION)``. This variable is
  required for most packages. The only exception are packages that only
  install some files in the targetinstall stage (e.g. from projectroot/).

``<PKG>_VERSION``
  The version of the package. It is used as the version for the ipk
  packages. As such, it is required for all packages that create such
  packages. Most target packages fall in this category.

``<PKG>_MD5``
  The md5 checksum of the source archive. PTXdist calculates the checksum
  before extracting the archive and will abort if does not match. Upstream
  project occasionally change the content of an archive without releasing a
  new version. This check helps to ensure that all developers work with the
  same source code.

``<PKG>_SUFFIX``
  The archive suffix without the leading '.', e.g. 'tar.gz' or 'zip'. This
  is only used locally to define ``<PKG>_URL`` and ``<PKG>_SOURCE``.

``<PKG>_URL``
  This is the download URL for the source archive. It is a space separated
  list of URLs. PTXdist will try each URL until it finds one that works.
  There are two main reasons to provide more than one URL: 1. Additional
  mirror(s) in case the main location is unavailable. 2. Some projects move
  old versions into a separate directory when a new version is released.
  Providing both versions of the URL ensures that PTXdist still has a
  working URL after the next upstream release.

  URLs can have options. Options are appended to the URL separated by ';'.
  For normal downloads the following options are supported:

  ``no-check-certificate`` to indicate that SSL certificate checking should
  be disabled.

  ``no-proxy`` to disable any configured proxy.

  ``cookie:<value>`` to specify a cookie that should be sent.

  Files in the local filesystem can be addressed with ``file://`` URLs. In
  this case, the URL can also point to a directory. In this case
  ``<PKG>_DIR`` will be a symlink to the specified directory. 'lndir://'
  can be used to create a shadow copy instead. For locations inside the BSP
  the URL should use ``$(PTXDIST_WORKSPACE)`` to define the correct
  absolute path.

  If no source archive is available, PTXdist can get the source from
  revision control systems. 'git' and 'svn' are currently supported. Note
  that this cannot be used to follow a branch! PTXdist will create the
  archive defined ``<PKG>_SOURCE`` and use it if available.

  Git URLs must either start with 'git://' or end with '.git'. They have a
  mandatory ``tag=<tagname>`` option.

  Svn URLs must start with 'svn://'. They have a mandatory
  ``rev=r<number>`` option.

``<PKG>_SOURCE``
  The location of the downloaded source archive. There should be no reason
  to set this to anything other than
  ``$(SRCDIR)/$(<PKG>).$(<PKG>_SUFFIX)``.

  For local URLs (``file://`` or ``lndir://``) ``<PKG>_SOURCE`` must not be
  set.

``<PKG>_DIR``
  This is the directory where the source archive is extracted. In most
  cases this is set to ``$(BUILDDIR)/$(<PKG>)``. However, if two packages
  use the same source archive, then something else must be used to make
  sure that they use different directories. See the rules for 'gdb' and
  'gdbserver' for an example.

``<PKG>_LICENSE``
  The license of the package. The SPDX license identifiers should be used
  here. Use ``proprietary`` for proprietary packages and ``ignore`` for
  packages without their own license, e.g. meta packages or packages that
  only install files from ``projectroot/``.

``<PKG>_LICENSE_FILES``
  A space separated list of URLs of license text files. The URLs must be
  ``file://`` URLs relative to ``<PKG>_DIR``. Absolute URLs using
  ``$(PTXDIST_WORKSPACE)`` can be used in case the license text is missing
  in the upstream archive. Arguments are appended with ';' as separator.
  The ``md5=<md5sum>`` argument is mandatory. It defines the md5 checksum
  of the full license text. ``startline=<number>;endline=<number>`` can be
  used in case the specified file contains more than just the license text,
  e.g. if the license is in the header of a source file. For non ASCII or
  UTF-8 files the encoding can be specified with ``encoding=<enc>``.

For most packages the variables described above are undefined by default.
However, for cross and host packages these variables default to the value
of the corresponding target package if it exists.

``<PKG>_CONFIG``
  This variable specifies a configuration file of some kind for the
  packages. For packages with ``<PKG>_CONF_TOOL`` set to ``kconfig`` the
  variable must specify an absolute path to the kconfig file. For image
  packages that use genimage, PTXdist will look for
  ``config/images/$(<PKG>_CONFIG)`` in the BSP and PTXdist in the usual
  search order.

``<PKG>_STRIP_LEVEL``
  When PTXdist extracts source archives, it will create ``<PKG>_DIR``
  first and then extracts the archive there. If ``<PKG>_STRIP_LEVEL`` is
  set to 1 (the default) then PTXdist removes the first directory level
  defined inside the archive. For most packages that this is the same as
  just extracting the archive. However, this is useful for packages with
  badly named top-level directories or packages where the directory must be
  renamed to avoid collisions (e.g. gdbserver).

  The main use-case for ``<PKG>_STRIP_LEVEL`` is to set it to 0 for
  packages without a top-level directory.

  In theory ``<PKG>_STRIP_LEVEL`` could be set to 2 or more to remove more
  than one directory level.

``<PKG>_BUILD_OOT``
  If this is set to ``YES`` then PTXdist will build the package out of
  tree. This is only supported for autoconf, qmake and cmake packages. The
  default is ``YES`` for cmake packages and ``NO`` for everything else.
  It will use ``$(<PKG>_DIR)-build`` as build directory.

  This is especially useful for ``file://`` URLS that point to directories to
  keep the source tree free of build files.

``<PKG>_SUBDIR``
  This is a directory relative to ``<PKG>_DIR``. If set, all build
  operations are executed in this directory instead. By default
  ``<PKG>_SUBDIR`` is undefined so all operations are executed in the
  top-level directory.

Build Environment for all Stages
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``<PKG>_PATH``
  This variable defines the PATH used by all build stages. It is evaluated
  as is, so it must start with ``PATH=``. If undefined, PTXdist will use
  ``PATH=$(CROSS_PATH)`` for target packages ``PATH=$(HOST_PATH)`` for host
  packages and ``PATH=$(HOST_CROSS_PATH)`` for cross packages. It must be
  set by packages that use the variable locally in the make file or if more
  directories are added, e.g. to
  ``PATH=$(PTXDIST_SYSROOT_CROSS)/bin/qt5:$(CROSS_PATH)`` for packages that
  use qmake from Qt5.

``<PKG>_CFLAGS``, ``<PKG>_CPPFLAGS``, ``<PKG>_LDFLAGS``
  Compiler, preprocessor and linker are never called directly in PTXdist.
  Instead, wrapper scripts are called that expand the command line before
  calling the actual tool. These variables can be used to influence these
  wrappers. The specified flags are added to the command line when
  appropriate. In most cases this it the preferred way to add additional
  flags. Adding them via environment variables or ``make`` arguments can
  have unexpected side effects, such as as overwriting existing defaults.

``<PKG>_WRAPPER_BLACKLIST``
  PTXdist has several options in the platformconfig that inject options in
  the compiler command line. This is used, for example, to add hardening
  options or change the debug options. This can occasionally cause problems
  for packages that use the compiler in certain ways, such as the Linux
  kernel or various bootloaders. With this variable a package can disable
  individual options by setting it to a space separated list of the
  corresponding Kconfig symbols (without the ``PTXCONF_`` prefix).

Prepare Stage
^^^^^^^^^^^^^

``<PKG>_CONF_ENV``
  The environment for the prepare stage. If undefined, PTXdist will use
  ``$(CROSS_ENV)`` for target packages, ``$(HOST_ENV)`` for host packages
  and ``$(HOST_CROSS_ENV)`` for cross packages. It must be set by packages
  that use the variable locally in the make file or if extra variables are
  added. In this case the definition should start with the default value.

``<PKG>_CONF_TOOL``
  This variable defines what tool is used to configure the package in the
  prepare stage. Possible values are:

   - ``NO`` to do nothing in the prepare stage.
   - ``autoconf`` for packages that use autoconf
   - ``qmake`` for qmake based packages. Note: the required Qt version must
     be selected.
   - ``cmake`` for cmake based packages. Note ``HOST_CMAKE`` must be
     selected to ensure, that cmake is available for configuration.
   - ``kconfig`` for kconfig based packages. Note ``<PKG>_CONFIG`` must be
     set as described above.
   - ``perl`` for perl modules.
   - ``python`` or ``python3`` for Python packages with a normal setup.py.

``<PKG>_CONF_OPT``
  This variable adds arguments to the command-line of the configuration
  tool. If undefined, PTXdist will use a default value that depends on the
  configuration tool of the package. This default value should also be used
  when adding additional options. The following defaults exist:

   - autoconf:
     ``$(CROSS_AUTOCONF_USR)``/``$(HOST_AUTOCONF)``/``$(HOST_CROSS_AUTOCONF)``
     for target/host/cross packages.
   - cmake: ``$(CROSS_CMAKE_USR)``/``$(HOST_CMAKE_OPT)`` for target/host
     packages. Cross packages cannot be built with cmake
   - qmake: ``$(CROSS_QMAKE_OPT)`` for host packages. Host and cross
     packages cannot be built with qmake.

  All other configuration tools have no default options. This variable is
  ignored for kconfig and python/python3.

.. _vars_compile:

Compile Stage
^^^^^^^^^^^^^

``<PKG>_MAKE_ENV``
  This variables defines additional environment variables for the compile
  stage. In most cases this variable remains undefined because all
  necessary defines are picked up in the prepare stage. For python/python3
  packages PTXdist will use the default value from ``<PKG>_CONF_ENV``.
  For packages without configuration tool this must be set correctly,
  usually based on the ``<PKG>_CONF_ENV`` default values, e,g.
  ``$(CROSS_ENV)`` for target packages.

``<PKG>_MAKE_OPT``
  This variables defines additional parameters to be forwarded to ``make`` in
  order to build the package. It defaults to nothing to let ``make`` traditionally
  build the first defined target.

``<PKG>_MAKE_PAR``
  This variables informs PTXdist, if this package can be built in parallel. Some
  (mostly very smart selfmade) buildsystems fail doing so. In this case this
  variable can be set to ``NO``. PTXdist will then build this package with one
  CPU only. The default is, to build packages in parallel.

.. _vars_install:

Install Stage
^^^^^^^^^^^^^

``<PKG>_INSTALL_OPT``
  This variable defaults to ``install`` which is used as a *target* for ``make``.
  It can be overwritten if the package needs a special target to install its
  results.

.. _pkg_pkgdir:

``<PKG>_PKGDIR``
  This variable must not be set by the user. It defines package
  install directory. All files will be installed relative to this
  directory. It can be used by manual install stages. It is defined as
  ``$(PKGDIR)/$(<PKG>)`` which expands to
  ``<platform-dir>/packages/foo-1.1.0`` on our *foo* example.

Targetinstall Stage
^^^^^^^^^^^^^^^^^^^

The *targetinstall* stage has no additional variables.

.. _image_packages:

Image Packages
^^^^^^^^^^^^^^

Image packages use a different set of variables. They have the same
``<PKG>`` and ``<PKG>_DIR`` variables as other packages, but the rest is
different.

``<PKG>_IMAGE``
  This is the filename of the image that is created by the rule. This is
  usually ``$(IMAGEDIR)/<image-file-name>``.

``<PKG>_FILES``
  This is a list of tar balls that are extracted to generate the content of
  the image. PTXdist will add the necessary dependencies to these files to
  recreate the image as needed. If a tar ball is created by another PTXdist
  package then this package should be selected in the menu file.

``<PKG>_PKGS``
  This is another mechanism to add files to the image. It can be uses
  instead of or in addition to ``<PKG>_FILES``. It must be set to a list of
  ptxdist packages (the lowercase name of the packages). PTXdist will add
  the necessary dependencies.

  Note that this will not ensure that the packages are enabled or that all
  all package dependencies are satisfied. ``$(PTX_PACKAGES_INSTALL)`` can
  be used to specify all enabled packages. Or ``$(call ptx/collection,
  $(PTXDIST_WORKSPACE)/configs/<collection-file-name>)`` can be uses to to
  specify the packages enabled by this collection. In both cases ``=`` must
  be uses instead of ``:=`` due to the makefile include order.

``<PKG>_CONFIG``
  ``genimage`` packages use this to specify the ``genimage`` configuration
  file. PTXdist will search for the specified file name in
  ``config/images/`` in the BSP, platform and PTXdist in the usual search
  order.

``<PKG>_NFSROOT``
  If this is set to ``YES`` then PTXdist will create a special nfsroot
  directory that contains only the files from the packages specified in
  ``<PKG>_PKGS``. This is useful if the normal nfsroot directory contains
  conflicting files from multiple images. The created nfsroot directory is
  ``<platform-dir>/nfsroot/<image-name>``.

``<PKG>_LABEL``
  This is a tar label to put on an image. This is supported by
  ``image-root-tgz`` and images created with the ``image-tgz`` template.
