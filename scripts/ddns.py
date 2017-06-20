#!/usr/bin/env python3
import requests
import sys

def main(hostname, password, addr):
    cert = "root.crt"
    url = "https://dyn.dns.he.net/nic/update?hostname={}&password={}&myip={}".format(hostname, password, addr)
    r = requests.get(
        url,
        headers={
            'User-Agent': 'curl/7.43.0'
        },
        verify = cert,
        timeout=5,
        proxies = proxies,
        ).text
    print(r)

if __name__ == "__main__":
    try:
        proxies = {'http':sys.argv[3], 'https':sys.argv[3]}
        ip = requests.get('https://redirector.gvt1.com/report_mapping').text.split()[0]
        main(sys.argv[1], sys.argv[2], ip)
    except:
        print('update failed')
