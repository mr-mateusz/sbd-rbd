:: 1. Generate data to insert
python generate_insert.py > insert_data.sql

:: 2. Docker network
docker network create -d bridge roachnet

:: 3. Run containers
docker-compose up -d

:: 4. Cluster init
docker exec -it roach1 ./cockroach init --insecure

:: 5. Copy scripts to container
docker cp create_db_script.sql roach1:/cockroach/create_db_script.sql
docker cp insert_data.sql roach1:/cockroach/insert_data.sql

docker cp query1.sql roach1:/cockroach/query1.sql
docker cp query2.sql roach1:/cockroach/query2.sql
docker cp query3.sql roach1:/cockroach/query3.sql

:: 6. Run scripts inside docker container
docker exec -it roach1 bash
./cockroach sql --insecure < create_db_script.sql
./cockroach sql --insecure < insert_data.sql

:: 7. Run queries
./cockroach sql --insecure < query1.sql
./cockroach sql --insecure < query2.sql
./cockroach sql --insecure < query3.sql


:: 8. Show nodes in cluster
./cockroach node status --insecure
::
./cockroach sql --insecure
:: Show transaction table ranges
SHOW RANGES FROM TABLE sale.transaction;
:: Simulate workload on node in region without leaseholder replica (set correct node as param)
python simulate_workload.py roach2
:: Check if leaseholder has changed
SHOW RANGES FROM TABLE sale.transaction;


:: 9. Stop and remove containers
docker-compose down
docker volume prune -f
