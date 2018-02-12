#!/bin/sh
#分布式索引的 增量更新   
/usr/local/sphinx/bin/indexer delta_user0 --rotate
/usr/local/sphinx/bin/indexer --merge idx_user0 delta_user0  --rotate --merge-dst-range deleted 0 0
sleep 12s
/usr/local/sphinx/bin/indexer delta_user1 --rotate
/usr/local/sphinx/bin/indexer --merge idx_user1 delta_user1  --rotate --merge-dst-range deleted 0 0
sleep 12s
/usr/local/sphinx/bin/indexer delta_user2 --rotate
/usr/local/sphinx/bin/indexer --merge idx_user2 delta_user2  --rotate --merge-dst-range deleted 0 0
sleep 12s
/usr/local/sphinx/bin/indexer delta_user3 --rotate
/usr/local/sphinx/bin/indexer --merge idx_user3 delta_user3  --rotate --merge-dst-range deleted 0 0
sleep 12s
/usr/local/sphinx/bin/indexer delta_user4 --rotate
/usr/local/sphinx/bin/indexer --merge idx_user4 delta_user4  --rotate --merge-dst-range deleted 0 0


