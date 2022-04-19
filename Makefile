# This Makefile requires rsync 3 or newer.
RSYNC_OPTIONS =
SOURCE_CHARSET = utf-8-mac
DESTINATION = corpora:Corpora
DESTINATION_CHARSET = utf-8

corpora:
	tools/build.js

dry-sync:
	rsync -Oclmrtvz --del --dry-run --filter=". .rsync-filter" --iconv=$(SOURCE_CHARSET),$(DESTINATION_CHARSET) $(RSYNC_OPTIONS) . $(DESTINATION)

sync:
	rsync -Oclmrtvz --del --filter=". .rsync-filter" --iconv=$(SOURCE_CHARSET),$(DESTINATION_CHARSET) $(RSYNC_OPTIONS) . $(DESTINATION)
