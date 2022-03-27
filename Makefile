RSYNC_OPTIONS =
DESTINATION = corpora:Corpora

help:
	echo "Valid rules are: help, dry-run, sync."

dry-run:
	rsync -Olmrtvz --del --dry-run --filter=". .rsync-filter" $(RSYNC_OPTIONS) . $(DESTINATION)

sync:
	rsync -Olmrtvz --del --filter=". .rsync-filter" $(RSYNC_OPTIONS) . $(DESTINATION)
