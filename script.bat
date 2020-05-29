:: 1. Generate data to insert
python generate_insert.py > insert_data.sql

:: 2. Docker network
docker network create -d bridge roachnet

:: 3. Run containers
docker-compose up -d

:: 4. Cluster init
docker exec -it roach1 ./cockroach init --insecure

:: 5. Copy data to conatiner
docker cp create_db_scripts.sql roach1:/cockroach/create_db_scripts.sql
docker cp insert_data.sql roach1:/cockroach/insert_data.sql

:: 6. Run scripts inside docker container
docker exec -it roach1 bash
./cockroach sql --insecure < create_db_scripts.sql
./cockroach sql --insecure < insert_data.sql

\q



:: Stop and remove containers
docker-compose down
docker volume prune -f
