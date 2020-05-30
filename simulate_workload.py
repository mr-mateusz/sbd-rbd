import argparse
import random
import time
from datetime import datetime, timedelta

import psycopg2
import psycopg2.errorcodes


def get_args():
    ap = argparse.ArgumentParser(description="Simulate workload on chosen container")

    ap.add_argument('container',
                    metavar='node_name',
                    type=str,
                    help="Container node name")

    args = ap.parse_args()
    return args


def print_data(conn, n):
    # Get all pos ids
    with conn.cursor() as cur:
        cur.execute("SELECT distinct id FROM point_of_sale order by id")
        rows = cur.fetchall()
        conn.commit()
        pos_ids = [i[0] for i in rows]
        print(f"Time: {time.asctime()}")
        print(pos_ids)

    # Get all transaction ids
    with conn.cursor() as cur:
        cur.execute("SELECT distinct id FROM product order by id")
        rows = cur.fetchall()
        conn.commit()
        product_ids = [i[0] for i in rows]
        print(f"Time: {time.asctime()}")
        print(product_ids)

    # Get all transaction type ids
    with conn.cursor() as cur:
        cur.execute("SELECT distinct id FROM transaction_type order by id")
        rows = cur.fetchall()
        conn.commit()
        transaction_type_ids = [i[0] for i in rows]
        print(f"Time: {time.asctime()}")
        print(transaction_type_ids)

    # Generate and insert random transaction
    pos_id = random.choice(pos_ids)
    transaction_type_id = random.choice(transaction_type_ids)
    product_id = random.choice(product_ids)
    transaction_date = (datetime.now() + timedelta(days=n + 365)).isoformat()[:10]
    print( f'INSERT INTO transaction (pos_id, transaction_type_id, product_id, transaction_date) VALUES ({pos_id}, {transaction_type_id}, {product_id}, \'{transaction_date}\')')
    with conn.cursor() as cur:
        cur.execute(
            f'INSERT INTO transaction (pos_id, transaction_type_id, product_id, transaction_date) VALUES ({pos_id}, {transaction_type_id}, {product_id}, \'{transaction_date}\')')
    conn.commit()


def main():
    args = get_args()

    db = 'sale'
    host = '192.168.99.100'

    ports = {
        'roach1': 26257,
        'roach2': 26258,
        'roach3': 26259
    }
    port = ports[args.container]

    connection_string = f'postgresql://root@{host}:{port}/{db}?sslmode=disable'
    # print(connection_string)
    # exit(1)
    conn = psycopg2.connect(connection_string)

    how_many = 5000
    for i in range(how_many):
        print(f'{i}/{how_many}')
        print_data(conn, i)

    # Close communication with the database.
    conn.close()


if __name__ == '__main__':
    main()
