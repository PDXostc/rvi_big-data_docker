CREATE KEYSPACE IF NOT EXISTS rvi_demo WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1 }; 
CREATE TABLE IF NOT EXISTS rvi_demo.trace_by_car(
	id text,
	year int,
   	month int,
   	day int,
   	hour int,
   	date timestamp,
   	lat decimal,
   	lng decimal,
   	is_occupied boolean,
   	PRIMARY KEY ((id), year, month, day, hour)
) WITH CLUSTERING ORDER BY (year DESC, month DESC, day DESC, hour DESC);

CREATE TABLE IF NOT EXISTS rvi_demo.traces_by_time(
	year int,
   	month int,
   	day int,
   	hour int,
   	minute int,	
   	id text,
   	lat decimal,
   	lng decimal,
   	is_occupied boolean,
   	PRIMARY KEY ((year, month, day, hour, minute), id)
);