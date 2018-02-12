#!/bin/sh
/usr/local/sphinx/bin/indexer delta_city --rotate
/usr/local/sphinx/bin/indexer --merge city delta_city  --rotate --merge-dst-range deleted 0 0

