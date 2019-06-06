.. _rulefile:

Rule File Layout
----------------

Each rule file provides PTXdist with the required steps (in PTXdist called
*stages*) to be done on a per package base:

1. get
2. extract

   - extract.post

3. prepare
4. compile
5. install

   - install.pack
   - install.unpack
   - install.post

6. targetinstall

   - targetinstall.post

.. note::

  Host, image and cross packages don't need to install anything in the target file system.
  Therefore, PTXdist only respects the *targetinstall* and *targetinstall.post*
  stages for packages whose name doesn't start with ``host-``, ``image-``, or ``cross-``.

  When you want to depend on the output of a certain image package, you can
  usually use its image name as an `additional prerequisite <make-prereq-types_>`_
  in your make rule for the dependent stage.

.. _make-prereq-types: https://www.gnu.org/software/make/manual/make.html#Prerequisite-Types

Default stage rules
~~~~~~~~~~~~~~~~~~~

As for most packages these steps can be done in a default way, PTXdist
provides generic rules for each package. If a package’s rule file does
not provide a specific stage rule, the default stage rule will be used
instead.

.. Important::
  Omitting one of the stage rules **does not mean** that PTXdist skips
  this stage!
  In this case the default stage rule is used instead.

get Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^

If the *get* stage is omitted, PTXdist runs instead:

.. code-block:: make

    $(STATEDIR)/<pkg>.get:
    	@$(call targetinfo)
    	@$(call touch)

Which means this step is skipped.

If the package is an archive that must be downloaded from the web, the
following rule must exist in this case:

.. code-block:: make

    $(<PKG>_SOURCE):
    	@$(call targetinfo)
    	@$(call get, <PKG>)

extract Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^

If the *extract* stage is omitted, PTXdist runs instead:

.. code-block:: make

    $(STATEDIR)/<pkg>.extract:
    	@$(call targetinfo)
    	@$(call clean, $(<PKG>_DIR))
    	@$(call extract, <PKG>)
    	@$(call patchin, <PKG>)
    	@$(call touch)

Which means a current existing directory of this package will be
removed, the archive gets freshly extracted again and (if corresponding
patches are found) patched.

extract.post Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is an optional stage, mainly used to somehow prepare a package for the
next *prepare* stage step. This stage can be used to generate a ``configure``
script out of an autotoolized ``configure.ac`` file for example. This separation
from the *extract* stage is useful to be able to extract a package for a quick
look into the sources without the need to build all the autotools first. The
autotoolized PTXdist templates makes use of this feature. Refer
:ref:`adding_src_autoconf_templates` for further details.

prepare Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^

If the *prepare* stage is omitted, PTXdist runs a default stage rule,
which looks like this:

.. code-block:: make

    $(STATEDIR)/<pkg>.prepare:
    	@$(call targetinfo)
    	@$(call world/prepare, <PKG>)
    	@$(call touch)

What ``world/prepare`` does depends on some variable settings.

If the package’s rule file defines ``<PKG>_CONF_TOOL`` to ``NO``,
this stage is simply does nothing.

All rules files can create the ``<PKG>_CONF_ENV`` variable and should
define it at least to ``$(CROSS_ENV)`` (the default) if the prepare stage
is used.

If the package’s rule file defines ``<PKG>_CONF_TOOL`` to
``autoconf`` (``FOO_CONF_TOOL = autoconf`` for our *foo* example),
PTXdist treats this package as an autotoolized package and
``world/prepare`` expands to something like this:

.. code-block:: sh

    cd ${<PKG>_DIR}/${<PKG>_SUBDIR} && \
    	${<PKG>_PATH} ${<PKG>_CONF_ENV} \
    	./configure ${<PKG>_CONF_OPT}

The ``<PKG>_CONF_OPT`` should at least be defined to
``$(CROSS_AUTOCONF_USR)``.

If the package’s rule file defines ``<PKG>_CONF_TOOL`` to ``cmake``
(``FOO_CONF_TOOL = cmake`` for our *foo* example), PTXdist treats this
package as a *cmake* based package and ``world/prepare`` expands to
something like this:

.. code-block:: sh

    cd ${<PKG>_DIR} && \
    	${<PKG>_PATH} ${<PKG>_CONF_ENV} \
    	cmake ${<PKG>_CONF_OPT}

The ``<PKG>_CONF_OPT`` should at least be defined to
``$(CROSS_CMAKE_USR)`` or ``$(CROSS_CMAKE_ROOT)``.

If the package’s rule file defines ``<PKG>_CONF_TOOL`` to ``qmake``
(``FOO_CONF_TOOL = qmake`` for our *foo* example), PTXdist treats this
package as a *qmake* based package and ``world/prepare`` expands to
something like this:

.. code-block:: sh

    cd ${<PKG>_DIR} && \
    	${<PKG>_PATH} ${<PKG>_CONF_ENV} \
    	qmake ${<PKG>_CONF_OPT}

The ``<PKG>_CONF_OPT`` should at least be defined to
``$(CROSS_QMAKE_OPT)``.

compile Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^

If the *compile* stage is omitted, PTXdist runs instead:

.. code-block:: make

    $(STATEDIR)/<pkg>.compile:
    	@$(call targetinfo)
    	@$(call world/compile, <PKG>)
    	@$(call touch)

Except in some corner cases, ``world/compile`` expands to something like
this:

.. code-block:: sh

    cd ${<PKG>_DIR} && \
    	${<PKG>_PATH} ${<PKG>_MAKE_ENV} \
    	${MAKE} ${<PKG>_MAKE_OPT} ${PARALLELMFLAGS}

The variables that are used here are described in the :ref:`Compile
Stage<vars_compile>` section of the variable reference.

``PARALLELMFLAGS`` can be used in custom compile stages. The default stage
uses the same value if ``<PKG>_MAKE_PAR`` is set to ``YES``.

install Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^

If the *install* stage is omitted, PTXdist runs instead:

.. code-block:: make

    $(STATEDIR)/<pkg>.install:
    	@$(call targetinfo)
    	@$(call world/install, <PKG>)
    	@$(call touch)

Except in some corner cases, ``world/install`` expands to something like
this:

.. code-block:: sh

    cd ${<PKG>_DIR} && \
    	${<PKG>_PATH} ${<PKG>_MAKE_ENV} \
    	${MAKE} ${<PKG>_INSTALL_OPT}

The variables that are used here are described in the :ref:`Install
Stage<vars_install>` section of the variable reference.

At the end of this stage, all relevant files must be installed in the
:ref:`package install directory<pkg_pkgdir>`.

install.pack Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *install.pack* should not be overwritten. It consists of two steps. The
first is, to make the installed files relocatable. This is necessary to
ensure that everything works correctly once the files are copied to
*sysroot* in *install.post*. If creating :ref:`pre-built archives<devpkgs>`
is enabled, then the second step is to create the archive for the package.

install.unpack Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *install.unpack* is only executed if using :ref:`pre-built
archives<devpkgs>` is enabled. In this case, it replaces all previous
stages. Here, the pre-built is extract.

install.post Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *install.post* is mostly internal. Few packages need to customize it.
It copies all files from the :ref:`package install directory<pkg_pkgdir>`
into the corresponding *sysroot*.

targetinstall Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is no default rule for a package’s *targetinstall* state. PTXdist
has no idea what is required on the target at run-time. This stage is up
to the developer only. Refer to section :ref:`reference_macros`
for further info on how to select files to be included in the target’s
root filesystem.

targetinstall.post Stage Default Rule
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *targetinstall.post* stage does nothing by default. It can be used to
do some work after the *targetinstall* stage.

Skipping a Stage
~~~~~~~~~~~~~~~~

For the case that a specific stage should be really skipped, an empty rule must
be provided:

.. code-block:: make

    $(STATEDIR)/<pkg>.<stage_to_skip>:
    	@$(call targetinfo)
    	@$(call touch)

Replace the <stage_to_skip> by ``get``, ``extract``, ``prepare``,
``compile``, ``install`` or ``targetinstall``.


