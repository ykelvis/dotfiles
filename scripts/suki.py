#!/usr/bin/env python3
from os import devnull
import sys
import json
import curses
import subprocess
import requests
from math import ceil


class suki:
    def __init__(self, name, passwd):
        self.name = name
        self.passwd = passwd
        self.progress = 0
        self.all_bangumi = {}
        self.bangumi_list = {}
        self.episode_list = {}
        self.onair_anime = {}
        self.onair_dorama = {}
        self.selections = None
        self.url_login = 'https://suki.moe/api/user/login'
        self.url_all_bangumi = 'https://suki.moe/api/home/bangumi?count=-1&order_by=air_date&page=1&sort=desc'
        self.url_my_bangumi = 'https://suki.moe/api/home/my_bangumi'
        self.url_bangumi_detail = 'https://suki.moe/api/home/bangumi/'
        self.url_episode_detail = 'https://suki.moe/api/home/episode/'
        self.url_onair_anime = 'https://suki.moe/api/home/on_air?type=2'
        self.url_onair_dorama = 'https://suki.moe/api/home/on_air?type=6'
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
        curses.noecho()
        curses.cbreak()
        curses.start_color()
        self.current_title='/'
        self.position = 1
        self.page = 1
        self.screen.keypad(1)
        self.screen.border(0)
        curses.init_pair(1,curses.COLOR_BLACK, curses.COLOR_CYAN)
        self.highlightText = curses.color_pair(1)
        self.normalText = curses.A_NORMAL
        curses.curs_set(0)
        self.max_row = 20 #max number of rows
        self.box = curses.newwin(self.max_row + 2, 70, 1, 1)
        self.box.box()

    def refresh_screen(self):
        self.screen.clear()
        self.screen.refresh()
        self.screen.addstr('suki.moe - ' + self.name + ' ' + self.current_title)
        self.screen.addstr(3, 72, "Home: r")
        self.screen.addstr(4, 72, "UP: k/↑")
        self.screen.addstr(5, 72, "DOWN: j/↓")
        self.screen.addstr(6, 72, "Enter: l/enter")
        self.screen.addstr(7, 72, "Quit: q")

    def get_json(self, url):
        ret = self.session.get(url)
        ret = json.loads(ret.text)
        return ret

    def login(self):
        ret = self.session.post(self.url_login, data=self.login_data)
        if ret.status_code != 200:
            self.add_to_screen({1: ['login failed.']})
        self.show_mainmenu()

    def show_mainmenu(self):
        self.current_title = '/ '
        self.refresh_screen()
        ret = self.get_json(self.url_onair_anime)
        j = 1
        for i in ret['data']:
            self.onair_anime[j] = (i['name'], i['id'])
            j += 1
        ret = self.get_json(self.url_onair_dorama)
        j = 1
        for i in ret['data']:
            self.onair_dorama[j] = (i['name'], i['id'])
            j += 1
        self.onair_list = [None ,self.onair_anime, self.onair_dorama]
        self.add_to_screen({1: ['on air anime'], 2: ['on air dorama'], 3: ['my watchlist'], 4: ['all bangumi']})
        self.progress = 0

    def make_bangumi_list(self, url):
        self.bangumi_list = {}
        ret = self.get_json(url)
        j = 1
        for i in ret['data']:
            self.bangumi_list[j] = (i['name'], i['id'])
            j += 1
        self.selections = [str(i) for i in self.bangumi_list.keys()]

    def my_bangumi(self):
        self.position = 1
        self.page = 1
        self.make_bangumi_list(self.url_my_bangumi)
        self.add_to_screen(self.bangumi_list)
        self.progress = 1
        self.current_title = '/ '

    def bangumi_detail(self, bgm_id):
        self.episode_list = {}
        ret = self.get_json(self.url_bangumi_detail + bgm_id[1])
        j = 1
        for i in ret['data']['episodes']:
            if i.get('id', None):
                self.episode_list[j] = (i['name'], i['id'])
                j += 1
        self.selections = [str(i) for i in self.episode_list.keys()]
        self.current_title += ret['data']['name']
        self.add_to_screen(self.episode_list)
        self.progress = 2

    def episode_detail(self, episode_id):
        ret = self.get_json(self.url_episode_detail + episode_id[1])
        if not ret.get('video_files', None):
            self.screen.addstr('episode not valid.')
        else:
            # print(ret['video_files'][0]['url'])
            subprocess.run(['mpv', ret['video_files'][0]['url']], stdout=open(devnull, 'w'))
            # self.my_bangumi()

    def add_to_screen(self, kw, title=''):
        self.refresh_screen()
        self.current_text=kw
        self.row_num = len(kw.keys())
        self.pages = int( ceil( self.row_num / self.max_row ) )
        if self.row_num == 0:
            self.box.addstr(1, 1, "There aren't strings", self.highlightText)
        else:
            for i in range(1, self.max_row + 1):
                if (i == self.position):
                    self.box.addstr(i, 2,  str(i) + ". " + kw[i][0], self.highlightText)
                else:
                    self.box.addstr(i, 2,  str(i) + ". " + kw[i][0], self.normalText)
                if i == self.row_num:
                    break
        self.refresh_screen()
        self.box.refresh()

    def main_loop(self):
        key = self.screen.getch()
        while True:
            if key in (curses.KEY_DOWN, ord('j')):
                if self.page == 1:
                    if self.position < self.row_num:
                        self.position = self.position + 1
                    else:
                        if self.pages > 1:
                            self.page = self.page + 1
                            self.position = 1 + (self.max_row * (self.page - 1))
                elif self.page == self.pages:
                    if self.position < self.row_num:
                        self.position = self.position + 1
                else:
                    if self.position < self.max_row + (self.max_row * (self.page - 1)):
                        self.position = self.position + 1
                    else:
                        self.page = self.page + 1
                        self.position = 1 + (self.max_row * (self.page - 1))
            elif key in (curses.KEY_UP, ord('k')):
                if self.page == 1:
                    if self.position > 1:
                        self.position = self.position - 1
                else:
                    if self.position > (1 + (self.max_row * (self.page - 1))):
                        self.position = self.position - 1
                    else:
                        self.page = self.page - 1
                        self.position = self.max_row + (self.max_row * (self.page - 1))
            elif key == curses.KEY_LEFT:
                if self.page > 1:
                    self.page = self.page - 1
                    self.position = 1 + (self.max_row * (self.page - 1))

            elif key == curses.KEY_RIGHT:
                if self.page < self.pages:
                    self.page = self.page + 1
                    self.position = (1 + (self.max_row * (self.page - 1)))
            elif key in (ord("\n"), ord("l")):
                if self.progress == 0:
                    if self.position == 1:
                        self.make_bangumi_list(self.url_onair_anime)
                        self.add_to_screen(self.onair_list[self.position])
                    elif self.position == 2:
                        self.make_bangumi_list(self.url_onair_dorama)
                        self.add_to_screen(self.onair_list[self.position])
                    elif self.position == 3:
                        self.my_bangumi()
                    elif self.position == 4:
                        self.make_bangumi_list(self.url_all_bangumi)
                        self.add_to_screen(self.bangumi_list)
                    self.progress = 1
                elif self.progress == 1:
                    self.bangumi_detail(self.bangumi_list[self.position])
                elif self.progress == 2:
                    self.episode_detail(self.episode_list[self.position])
                else:
                    pass
                self.position = 1
                self.page = 1
            elif key == ord("q"):
                curses.nocbreak()
                curses.endwin()
                break
            elif key == ord("r"):
                self.show_mainmenu()

            self.box.erase()
            self.screen.border(0)
            self.box.border(0)
            for i in range(1 + (self.max_row * (self.page - 1)), self.max_row + 1 + (self.max_row * (self.page - 1))):
                if self.row_num == 0:
                    self.box.addstr(1, 1, "There aren't strings", self.highlightText)
                else:
                    if (i + (self.max_row * (self.page - 1)) == self.position + (self.max_row * (self.page - 1))):
                        self.box.addstr(i - (self.max_row * (self.page - 1)), 2, str(i) + ". " + self.current_text[i][0], self.highlightText)
                    else:
                        self.box.addstr(i - (self.max_row * (self.page - 1)), 2, str(i) + ". " + self.current_text[i][0], self.normalText)
                    if i == self.row_num:
                        break

            self.refresh_screen()
            self.box.refresh()
            key = self.screen.getch()

if __name__ == '__main__':
    USERNAME = sys.argv[1]
    PASSWORD = sys.argv[2]
    
    # try:
    sk = suki(USERNAME, PASSWORD)
    sk.login()
    sk.main_loop()
    # except:
        # curses.nocbreak()
        # curses.endwin()
