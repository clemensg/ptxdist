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
# clean
#
# Cleanup the given directory or file.
#
clean = \
	ptx_make_target="$@" \
	ptxd_make_clean "$(strip $(1))"


# vim: syntax=make
