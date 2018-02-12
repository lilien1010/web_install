#!/bin/sh
/usr/local/sphinx/bin/indexer delta_user --rotate
/usr/local/sphinx/bin/indexer --merge user delta_user  --rotate --merge-dst-range deleted 0 0

