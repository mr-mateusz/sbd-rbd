
from random import randint
from random import choice
from datetime import date
import string

n_pos = 200
store_id = 9
transaction_type_id = 5
product_id = 11

n_transaction = 1000

upper_letters = string.ascii_uppercase
ascii_letters = string.ascii_letters
end_line = ","

print("INSERT INTO sale.point_of_sale")
print("(\n\tid,\n\tpos_code,\n\tstore_id\n)")
print("VALUES")

for i in range(0, n_pos):
    prefix_code = "".join(choice(upper_letters) for _ in range(0, 2))
    midfix_code = randint(10000, 99999)
    endfix_code = "".join(choice(ascii_letters) for _ in range(0, 5))
    suffix_code = randint(100, 999)
    store_code = randint(1, store_id)

    if(i == n_pos-1):
        end_line = ";"

    print("({},'_{}-[{}={}]_{}',{}){}".format(i+1, prefix_code, midfix_code,
                                              endfix_code, suffix_code, store_code,
                                              end_line))

end_line = ","

print("")
print("INSERT INTO sale.transaction")
print("(\n\tpos_id,\n\ttransaction_type_id,\n\tproduct_id,\n\ttransaction_date\n)")
print("VALUES")

for i in range(0, n_transaction):

    i_pos = randint(1, n_pos)
    i_tran = randint(1, transaction_type_id)
    i_prod = randint(1, product_id)

    year = randint(2019, 2020)
    month = randint(1, 12)
    day = randint(1, 31)

    try:
        i_date = date(year, month, day)
    except Exception as e:
        i_date = date(2020, 2, 28)

    if(i == n_transaction-1):
        end_line = ";"

    print("({},{},{},'{}'){}".format(i_pos,
                                     i_tran,
                                     i_prod,
                                     i_date,
                                     end_line))
