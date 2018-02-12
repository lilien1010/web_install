#!/bin/sh
#分布式索引的全量更新
/usr/local/sphinx/bin/indexer idx_user0 --rotate
sleep 5s
/usr/local/sphinx/bin/indexer idx_user1 --rotate
sleep 5s
/usr/local/sphinx/bin/indexer idx_user2 --rotate
sleep 5s
/usr/local/sphinx/bin/indexer idx_user3 --rotate
sleep 5s
/usr/local/sphinx/bin/indexer idx_user4 --rotate

