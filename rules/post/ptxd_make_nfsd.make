# -*-makefile-*-
#
# Copyright (C) 2012 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_nfsd: $(STATEDIR)/host-unfs3.install.post
	@$(call image/env) \
	ptxd_make_nfsd

# vim: syntax=make
