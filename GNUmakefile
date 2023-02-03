# © 2022–2023 Margaret KIBI
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# This Makefile requires rsync 3 or newer.
SHELL = /bin/sh

RSYNC_OPTIONS =
SOURCE_CHARSET = utf-8-mac
DESTINATION = corpora:Corpora
DESTINATION_CHARSET = utf-8

override makefiles = $(wildcard ~*/Makefile) $(wildcard ~*/GNUmakefile)
override makefilephonies = $(patsubst ~%,%,$(dir $(makefiles)))$(notdir $(makefiles))

all: corpora makefiles

makefiles: $(makefilephonies) ;

$(makefilephonies): %: ~%
	@echo "Running Makefile: ./$<"
	@$(MAKE) -C $(dir $<) -f $(notdir $<)

corpora:
	@tools/build.js

dry-sync:
	rsync -Oclmrtvz --del --dry-run --filter=". .rsync-filter" --iconv=$(SOURCE_CHARSET),$(DESTINATION_CHARSET) $(RSYNC_OPTIONS) . $(DESTINATION)

sync:
	rsync -Oclmrtvz --del --filter=". .rsync-filter" --iconv=$(SOURCE_CHARSET),$(DESTINATION_CHARSET) $(RSYNC_OPTIONS) . $(DESTINATION)

.PHONY: corpora sync dry-sync $(makefilephonies)
