import configparser
import base64
import sys


def main(path):
    p = configparser.ConfigParser(allow_no_value=True, strict=False)
    try:
        p.read(path, encoding='utf-8')
    except:
        print('read failed')
        return 0
    if not p.has_section('Proxy'):
        print('no proxy section found')
        return 0
    proxies = []
    for i in p.items('Proxy'):
        if i[1].startswith('custom'):
            userinfo = "{}:{}".format(i[1].split(",")[3], i[1].split(",")[4])
            userinfo = base64.b64encode(userinfo.encode()).decode()
            proxies.append("ss://{}@{}:{}#{}".format(userinfo,
                                                     i[1].split(",")[1],
                                                     i[1].split(",")[2],
                                                     i[0]))
    # proxies = ["{}:{}@{}:{}".format(i[1].split(',')[3],
                                    # i[1].split(',')[4],
                                    # i[1].split(',')[1],
                                    # i[1].split(',')[2])
               # for i in p.items('Proxy') if i[1].startswith('custom')]
    proxies = [i.replace(" ", "") for i in proxies]
    print(proxies)
    # proxies = ["ss://" +
               # base64.b64encode(i.replace(" ", "").encode()).decode()
               # for i in proxies]

    # [print(i) for i in proxies]


if __name__ == '__main__':
    if len(sys.argv) < 1:
        sys.exit()
    main(sys.argv[1])
