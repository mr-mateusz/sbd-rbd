:: 0. Generate data to insert
python generate_insert.py > insert_data.sql

:: 1. Run postgres container
docker run -e POSTGRES_PASSWORD=password -d --name pstgrs -p 54320:5432 postgres

:: 2. Copy scripts to container
docker cp create_db_script_postgres.sql pstgrs:create_db_script_postgres.sql
docker cp insert_data.sql pstgrs:insert_data.sql

docker cp query1.sql pstgrs:query1.sql
docker cp query2.sql pstgrs:query2.sql
docker cp query3.sql pstgrs:query3.sql

:: 3. Run scripts inside docker container
docker exec -it pstgrs bash

psql -U postgres < create_db_script_postgres.sql
psql -U postgres < insert_data.sql

psql -U postgres -c "select count(*) from sale.transaction"
:: 4. Run queries
psql -U postgres < query1.sql
psql -U postgres < query2.sql
psql -U postgres < query3.sql


:: 5. Remove container
docker stop pstgrs
docker rm pstgrs