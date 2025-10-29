import os

'''
with open("IntraDayAccountOTBRule_NewChange.csv", "rb") as file:
    try:
        file.seek(-2, os.SEEK_END)
        while file.read(1) != b'\n':
            file.seek(-2, os.SEEK_CUR)
    except OSError:
        file.seek(0)
    #last_line = file.readline().decode()
    last_line = file.readlinenumber()
    print(last_line)
'''


def _count_generator(reader):
    b = reader(1024 * 1024)
    while b:
        yield b
        b = reader(1024 * 1024)

with open('IntraDayAccountOTBRule_NewChange.csv', 'rb') as fp:
    c_generator = _count_generator(fp.raw.read)
    # count each \n
    count = sum(buffer.count(b'\n') for buffer in c_generator)
    print('Total lines:', count)