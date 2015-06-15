CONSISTENCY ALL;
DROP KEYSPACE IF EXISTS test;
CREATE KEYSPACE test 
WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 1} AND DURABLE_WRITES = true;
USE test;

