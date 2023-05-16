import psutil
from math import ceil


def main():

    cpu_count = psutil.cpu_count()

    print(cpu_count)

if __name__ == "__main__":
    main()