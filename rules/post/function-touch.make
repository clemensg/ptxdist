# -*-makefile-*-
#
# Copyright (C) 2004, 2005, 2006, 2007, 2008 by the PTXdist project
#               2009, 2010 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# touch
#
ifdef PTXDIST_QUIET
ifdef PTXDIST_FD_STDOUT
_touch_opt_output = echo "$$(ptxd_make_print_progress stop $(1))finished: $(PTX_COLOR_GREEN)$(notdir $(1))$(PTX_COLOR_OFF)" >&$(PTXDIST_FD_STDOUT);
endif
endif

touch =						\
	touch "$(@)";				\
	$(call _touch_opt_output,$(@))		\
	echo "finished target $(notdir $(@))"

# vim: syntax=make
