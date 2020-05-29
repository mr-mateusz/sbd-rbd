import time

import psycopg2
import psycopg2.errorcodes


def print_data(conn):
    with conn.cursor() as cur:
        cur.execute("SELECT * FROM point_of_sale")
        rows = cur.fetchall()
        conn.commit()
        print(f"Time: {time.asctime()}")
        for row in rows:
            print([str(cell) for cell in row])


def main():
    connection_string = 'postgresql://root@192.168.99.100:26257/sale?sslmode=disable'
    conn = psycopg2.connect(connection_string)

    how_many = 500
    for i in range(how_many):
        print(f'{i}/{how_many}')
        time.sleep(1)
        print_data(conn)

    # Close communication with the database.
    conn.close()


if __name__ == '__main__':
    main()
