RSYNC_OPTIONS =
DESTINATION = corpora:Corpora

corpora:
	tools/build.js

dry-sync:
	rsync -Olmrtvz --del --dry-run --filter=". .rsync-filter" $(RSYNC_OPTIONS) . $(DESTINATION)

sync:
	rsync -Olmrtvz --del --filter=". .rsync-filter" $(RSYNC_OPTIONS) . $(DESTINATION)
