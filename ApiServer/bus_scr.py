#coding:utf-8
from bs4 import BeautifulSoup
import urllib.request
from collections import deque
import json
import collections

def scr():
    html = urllib.request.urlopen("http://www.teu.ac.jp/campus/access/2017_kihon-a_bus.html")
    soup = BeautifulSoup(html, "lxml")
    res = soup.find("table").find("tbody").findAll("tr")
    array = []
    final = []
    jsonDict = collections.OrderedDict()
    counter = 0

    for i in res:
        array.append(i.get_text())

    queue = deque(array)
    queue.popleft()

    array = [] #array再初期化

    for i in range(len(queue)):
        array.append(queue[i].replace('\n',''))

    for i in array:
        counter+=1
        data = collections.OrderedDict()
        if i[:1] != "～":
            data["Campus"] = i[0:5]
            data["Station"] = i[5:10]
            data["CampusEnd"] = i[10:15]
        else:   #シャトル運行時
            data["Campus"] = "Shuttle"
            data["Station"] = "Shuttle"
            data["CampusEnd"] = "Shuttle"

        jsonDict["bus" + str(counter)] = data

    counter = 0
    #print(json.dumps(jsonDict)) #debug
    return json.dumps(jsonDict)

if __name__ == "__main__":
    scr()