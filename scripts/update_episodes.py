#!/usr/bin/env python3
import requests
import time

class Suki:
    def __init__(self, username, password, bangumi_id):
        self.bangumi_id = bangumi_id
        self.domain = "https://suki.moe"
        self.api_login = "{}/api/user/login".format(self.domain)
        self.api_episode = "{}/api/admin/episode".format(self.domain)
        self.api_bangumi = "{}/api/admin/bangumi".format(self.domain)
        self.epi_range = list(range(1,12))
        self.login(username, password)
        self.run()
        return

    def login(self, username, password):
        self.session = requests.Session()
        self.session.headers = {'User-Agent': 'Mozilla/5.0', 'Content-Type': 'application/json'}
        payload = {"name": username, "password": password, "remember": True}
        ret = self.session.post(self.api_login, json=payload)
        return

    def get_jsons(self):
        url_suki = "{}/{}".format(self.api_bangumi, self.bangumi_id)
        json_suki = self.session.get(url_suki).json()
        bgm_id = json_suki["data"]["bgm_id"]
        url_bgm = "http://api.bgm.tv/subject/{}?responseGroup=large".format(bgm_id)
        json_bgm = requests.get(url_bgm).json()
        return (json_bgm, json_suki)

    def set_on_air(self):
        url_suki = "{}/{}".format(self.api_bangumi, self.bangumi_id)
        json_suki = self.session.get(url_suki).json()
        json_suki["data"]["status"] = 1
        ret = self.session.put(url_suki, json=json_suki["data"])
        print(ret)

    def run(self):
        jsons = self.get_jsons()
        dic = {}
        for i in self.epi_range:
            _b, _s = None, {}
            for x in jsons[0]["eps"]:
                if int(x["sort"]) == i:
                    _b = x
                    break
            for y in jsons[1]["data"]["episodes"]:
                if int(y["episode_no"]) == i:
                    _s = y
                    break
            dic[i] = (_b, _s)

        changed, added = False, False
        for k, v in dic.items():
            if v[0] is None:
                print("episode", k, "not exist")
                continue

            # new episode
            if v[1] == {}:
                payload = {}
                payload["airdate"] = v[0]["airdate"]
                payload["bgm_eps_id"] = v[0]["id"]
                payload["duration"] = ""
                payload["episode_no"] = v[0]["sort"]
                payload["status"] = 0
                payload["name"] = v[0]["name"]
                payload["name_cn"] = v[0]["name_cn"]
                payload["bangumi_id"] = self.bangumi_id
                print("adding {} / ep{}".format(v[0]["name"], v[0]["sort"]))
                ret = self.session.post(self.api_episode, json=payload)
                print(ret)
                added = True

            # old episode
            else:
                print("checking ep{}".format(k))
                changed, payload = False, v[1]
                name = False if v[0]["name"]==v[1].get("name", None) else v[0]["name"]
                name_cn = False if v[0]["name_cn"]==v[1].get("name_cn", None) else v[0]["name_cn"]
                bgm_id = False if v[0]["id"]==v[1].get("bgm_eps_id", None) else v[0]["id"]
                airdate = False if v[0]["airdate"]==v[1].get("airdate", None) else v[0]["airdate"]
                if name:
                    print("name {} -> {}".format(v[1].get("name", "None"), v[0]["name"]))
                    payload["name"] = v[0]["name"]
                    changed = True
                if name_cn:
                    print("name_cn {} -> {}".format(v[1].get("name_cn", "None"), v[0]["name_cn"]))
                    payload["name_cn"] = v[0]["name_cn"]
                    changed = True
                if bgm_id:
                    print("bgm_id {} -> {}".format(v[1].get("bgm_eps_id", "None"), v[0]["id"]))
                    payload["bgm_eps_id"] = v[0]["id"]
                    changed = True
                if airdate:
                    print("airdate {} -> {}".format(v[1].get("airdate", "None"), v[0]["airdate"]))
                    payload["airdate"] = v[0]["airdate"]
                    changed = True
                if changed:
                    payload["update_time"] = int(time.time())
                    suki_epi_id = v[1]["id"]
                    url = "{}/{}".format(self.api_episode, suki_epi_id)
                    ret = self.session.put(url, json=payload)
                else:
                    print("pass {} / ep{}".format(v[0]["name"], v[0]["sort"]))

        if changed or added:
            print("gonna set bangumi status to on_air")
            self.set_on_air()

if __name__ == "__main__":
    import sys
    username = sys.argv[1]
    password = sys.argv[2]
    bangumi = sys.argv[3]
    suki = Suki(username, password, bangumi)
