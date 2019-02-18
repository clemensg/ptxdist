# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# world/execute
#
world/execute = \
	$(call world/env, $(1)) \
	pkg_execute_cmd="$(call ptx/escape,$(2))" \
	ptxd_make_world_execute

#
# execute
#
execute = \
	$(call world/env, $(1)) \
	pkg_execute_cmd="$(call ptx/escape,$(2))" \
	ptxd_make_execute


# vim: syntax=make
