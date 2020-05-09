docker network create -d bridge roachnet

docker-compose up -d

docker exec -it roach1 ./cockroach init --insecure

docker exec -it roach1 ./cockroach sql --insecure

CREATE DATABASE bank;
CREATE TABLE bank.accounts (id INT PRIMARY KEY, balance DECIMAL);
INSERT INTO bank.accounts VALUES (1, 1000.50);
SELECT * FROM bank.accounts;

docker exec -it roach2 ./cockroach sql --insecure

SELECT * FROM bank.accounts;

docker exec -it roach1 ./cockroach workload init movr
docker exec -it roach1 ./cockroach workload run movr --duration=5m


::http://192.168.99.100:8080/#/overview/list