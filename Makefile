RSYNC_OPTIONS =
DESTINATION = corpora:Corpora

corpora:
	tools/build.js

dry-sync:
	rsync -Olcmrtvz --del --dry-run --filter=". .rsync-filter" $(RSYNC_OPTIONS) . $(DESTINATION)

sync:
	rsync -Olcmrtvz --del --filter=". .rsync-filter" $(RSYNC_OPTIONS) . $(DESTINATION)
