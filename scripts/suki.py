#!/usr/bin/env python3
from os import devnull
import sys
import json
import curses
import subprocess
import requests


class suki:
    def __init__(self, name, passwd):
        self.name = name
        self.passwd = passwd
        self.progress = 0
        self.bangumi_list = {}
        self.episode_list = {}
        self.selections = None
        self.url_login = 'https://suki.moe/api/user/login'
        self.url_my_bangumi = 'https://suki.moe/api/home/my_bangumi'
        self.url_bangumi_detail = 'https://suki.moe/api/home/bangumi/'
        self.url_episode_detail = 'https://suki.moe/api/home/episode/'
        self.headers = {'origin': 'https://suki.moe',
                        'referer': 'https://suki.moe',
                        'content-type': 'application/json',
                        'accept': 'application/json, text/plain, */*',
                        'accept-encoding': 'gzip, deflate, br',
                        'user-agent': 'CURSERS 1.0'}
        self.login_data = json.dumps({"name": self.name,
                                      "password": self.passwd})
        self.session = requests.Session()
        self.session.proxies = {'http': None, 'https': None}
        self.session.headers = self.headers
        self.session.trust_env = False
        self.screen = curses.initscr()
        # curses.noecho()
        curses.curs_set(1)
        self.screen.keypad(1)
        self.screen.border(1)
        self.screen.scrollok(True)

    def login(self):
        ret = self.session.post(self.url_login, data=self.login_data)
        return ret

    def my_bangumi(self):
        self.bangumi_list = {}
        ret = self.session.get(self.url_my_bangumi)
        assert ret.ok
        ret = json.loads(ret.text)
        j = 1
        for i in ret['data']:
            self.bangumi_list[j] = (i['name'], i['id'])
            j += 1
        self.selections = [str(i) for i in self.bangumi_list.keys()]
        self.add_to_screen(self.bangumi_list, title='SUKI.MOE')
        self.progress = 0

    def bangumi_detail(self, bgm_id):
        self.episode_list = {}
        ret = self.session.get(self.url_bangumi_detail + bgm_id[1])
        assert ret.ok
        ret = json.loads(ret.text)
        j = 1
        for i in ret['data']['episodes']:
            if i.get('id', None):
                self.episode_list[j] = (i['name'], i['id'])
                j += 1
        self.selections = [str(i) for i in self.episode_list.keys()]
        self.add_to_screen(self.episode_list, title='SUKI.MOE ' + ret['data']['name'])
        self.progress = 1

    def episode_detail(self, episode_id):
        ret = self.session.get(self.url_episode_detail + episode_id[1])
        assert ret.ok
        ret = json.loads(ret.text)
        if not ret.get('video_files', None):
            self.screen.addstr('episode not valid.')
        else:
            print(ret['video_files'][0]['url'])
            subprocess.run(['mpv', ret['video_files'][0]['url']], stdout=open(devnull, 'w'))
            # self.my_bangumi()

    def add_to_screen(self, kw, title=''):
        self.screen.clear()
        self.screen.addstr(title + "\n")
        for k, v in kw.items():
            self.screen.addstr(str(k) + '. ' + v[0] + '\n')

    def main_loop(self):
        event = ''
        while True:
            keypress = self.screen.getkey()
            if keypress == "\n":
                if event in self.selections:
                    if self.progress == 0:
                        selection = int(event)
                        self.bangumi_detail(self.bangumi_list[selection])
                    elif self.progress == 1:
                        selection = int(event)
                        self.episode_detail(self.episode_list[selection])
                else:
                    pass
                event = ''
            elif keypress == "q":
                curses.nocbreak()
                curses.endwin()
                break
            elif keypress == "r":
                self.my_bangumi()
                event = ''
            else:
                event = event + keypress




if __name__ == '__main__':
    USERNAME = sys.argv[1]
    PASSWORD = sys.argv[2]

    sk = suki(USERNAME, PASSWORD)
    sk.login()
    sk.my_bangumi()
    sk.main_loop()
