#!/usr/bin/env python3
import sys
import json
import curses
import argparse
import requests
import subprocess
from os import devnull
from math import ceil


class suki:
    def __init__(self, host, name, passwd, player, proxy):
        self.host = host if "://" in host else "https://{}".format(host)
        self.host = self.host.rstrip("/")
        self.name = name
        self.passwd = passwd
        self.player = player
        self.progress = 0
        self.all_bangumi = {}
        self.bangumi_list = {}
        self.episode_list = {}
        self.onair_anime = {}
        self.onair_dorama = {}
        self.selections = None
        self.url_login = "{}/api/user/login".format(self.host)
        self.url_all_bangumi = "{}/api/home/bangumi?count=-1&order_by=air_date&page=1&sort=desc".format(self.host)
        self.url_my_bangumi = "{}/api/home/my_bangumi".format(self.host)
        self.url_bangumi_detail = "{}/api/home/bangumi/".format(self.host)
        self.url_episode_detail = "{}/api/home/episode/".format(self.host)
        self.url_onair_anime = "{}/api/home/on_air?type=2".format(self.host)
        self.url_onair_dorama = "{}/api/home/on_air?type=6".format(self.host)
        self.headers = {"origin": self.host,
                        "referer": self.host,
                        "content-type": "application/json",
                        "accept": "application/json, text/plain, */*",
                        "accept-encoding": "gzip, deflate, br",
                        "user-agent": "CURSERS 1.0"}
        self.login_data = json.dumps({"name": self.name,
                                      "password": self.passwd})
        self.session = requests.Session()
        self.session.proxies = {"http": proxy, "https": proxy}
        self.session.headers = self.headers
        self.session.trust_env = False
        self.screen = curses.initscr()
        self.current_title="/"
        self.position = 1
        self.page = 1
        self.max_row = 20
        self.max_col = 70
        self.screen.keypad(1)
        self.screen.border(0)
        curses.noecho()
        curses.cbreak()
        curses.start_color()
        curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_CYAN)
        self.highlightText = curses.color_pair(1)
        self.normalText = curses.A_NORMAL
        curses.curs_set(0)
        self.box = curses.newwin(self.max_row + 2, self.max_col, 1, 1)
        self.box.box()

    def refresh_screen(self):
        self.screen.clear()
        self.screen.refresh()
        self.screen.addstr(self.host.split("://")[1] + " - " + self.name + " " + self.current_title)
        self.screen.addstr(2, 72, "Home: r")
        self.screen.addstr(3, 72, "UP: k/↑")
        self.screen.addstr(4, 72, "DOWN: j/↓")
        self.screen.addstr(5, 72, "Enter: l/enter")
        self.screen.addstr(6, 72, "Page UP: ←")
        self.screen.addstr(7, 72, "Page DOWN: →")
        self.screen.addstr(8, 72, "Quit: q")

    def get_json(self, url, post=False, data={}):
        try:
            if post:
                ret = self.session.post(url, data=data, timeout=3)
            else:
                ret = self.session.get(url, timeout=3)
                ret = json.loads(ret.text)
        except:
            ret = None
        return ret

    def login(self):
        ret = self.get_json(self.url_login, post=True, data=self.login_data)
        if not ret or ret.status_code != 200:
            self.add_to_screen({1: ["login failed."]})
        else:
            self.show_mainmenu()

    def show_mainmenu(self):
        self.current_title = "/ "
        self.onair_list = [None ,self.onair_anime, self.onair_dorama]
        self.add_to_screen({1: ["on air anime"],
                            2: ["on air dorama"],
                            3: ["my watchlist"],
                            4: ["all bangumi"]})
        self.progress = 0
        ret = self.get_json(self.url_onair_anime)
        if not ret:
            self.add_to_screen({1: ["network error."]})
            return
        j, k = 1, 1
        for i in ret["data"]:
            self.onair_anime[j] = (i["name"], i["id"])
            j += 1
        ret = self.get_json(self.url_onair_dorama)
        if not ret:
            self.add_to_screen({1: ["network error."]})
            return
        for i in ret["data"]:
            self.onair_dorama[k] = (i["name"], i["id"])
            k += 1
        self.refresh_screen()
        self.box.refresh()

    def make_bangumi_list(self, url):
        self.bangumi_list = {}
        ret = self.get_json(url)
        if not ret:
            self.add_to_screen({1: ["network error."]})
            return
        j = 1
        for i in ret["data"]:
            self.bangumi_list[j] = (i["name"], i["id"])
            j += 1
        self.selections = [str(i) for i in self.bangumi_list.keys()]

    def my_bangumi(self):
        self.position = 1
        self.page = 1
        self.make_bangumi_list(self.url_my_bangumi)
        self.add_to_screen(self.bangumi_list)
        self.progress = 1
        self.current_title = "/ "

    def bangumi_detail(self, bgm_id):
        self.episode_list = {}
        ret = self.get_json(self.url_bangumi_detail + bgm_id[1])
        if not ret:
            self.add_to_screen({1: ["network error."]})
            return
        j = 1
        for i in ret["data"]["episodes"]:
            if i.get("id", None):
                self.episode_list[j] = (i["name"], i["id"])
                j += 1
        self.selections = [str(i) for i in self.episode_list.keys()]
        self.current_title += ret["data"]["name"]
        self.add_to_screen(self.episode_list)
        self.progress = 2

    def episode_detail(self, episode_id):
        ret = self.get_json(self.url_episode_detail + episode_id[1])
        if not ret:
            self.add_to_screen({1: ["network error."]})
            return
        if not ret.get("video_files", None):
            self.screen.addstr("episode not valid.")
        else:
            url = ret["video_files"][0]["url"]
            url = url if url.startswith("http") else self.host + url
            # self.add_to_screen({1:[url]})
            subprocess.run([self.player, url], stdout=open(devnull, "w"))
            # self.my_bangumi()

    def add_to_screen(self, kw, title=""):
        self.position = 1
        self.current_text=kw
        self.row_num = len(kw.keys())
        self.pages = int(ceil(self.row_num / self.max_row))
        if self.row_num == 0:
            self.box.addstr(1, 1, "nothing here.", self.highlightText)
        else:
            for i in range(1, self.max_row + 1):
                if (i == self.position):
                    self.box.addstr(i, 2,  str(i) + ". " + kw[i][0][:65], self.highlightText)
                else:
                    self.box.addstr(i, 2,  str(i) + ". " + kw[i][0][:65], self.normalText)
                if i == self.row_num:
                    break

    def main_loop(self):
        key = self.screen.getch()
        while True:
            if key in (curses.KEY_DOWN, ord("j")):
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
            elif key in (curses.KEY_UP, ord("k")):
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

    def run(self):
        try:
            self.login()
            self.main_loop()
        except:
            print("Unexpected error:", sys.exc_info())
            curses.nocbreak()
            curses.endwin()

if __name__ == "__main__":
    description = "{}\n\t{}\n\t{}".format("Command Line Utility for Albireo/Deneb",
                                          "https://github.com/lordfriend/Albireo",
                                          "https://github.com/lordfriend/Deneb")
    parser = argparse.ArgumentParser(description=description,
                                     formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument("-u","--username",
                        help="username of your account",
                        required=True,
                        dest="username")
    parser.add_argument("-p","--password",
                        help="password of your account",
                        required=True,
                        dest="password")
    parser.add_argument("--http-proxy",
                        help="set http proxy",
                        required=False,
                        dest="http_proxy",
                        default=None)
    parser.add_argument("--player",
                        help="local player to be used",
                        required=False,
                        dest="player",
                        default="mpv")
    parser.add_argument("link",
                        type=str,
                        nargs="+",
                        help="link to your site, https://site.com")
    args = vars(parser.parse_args())
    print(args)

    sk = suki(args["link"][0],
              args["username"],
              args["password"],
              args["player"],
              args["http_proxy"])
    sk.run()
