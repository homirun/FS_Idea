from flask import Flask, render_template, make_response, jsonify
import sys
import mysql.connector
import datetime
import bus_scr
import json

def editDB(query, pattern):
    host_ = "localhost"
    data_base = "FS_test"
    user_ = "client"
    password_ = ""
    connection = mysql.connector.connect(user = user_, password = password_, host = host_, database = data_base)
    cursor = connection.cursor (dictionary = True)
    cursor.execute(query)
    if pattern == "get":
        result = cursor.fetchall()
    elif pattern == "set":
        connection.commit()
    cursor.close()
    connection.close()
    if pattern == "get":
        return result

app = Flask(__name__)

@app.route('/')
def hello():
    name = "BUS API!!!!!!"
    return name

@app.route('/hm/people/count/')
def count():
    return render_template('bus_count.html',titlename="count")
@app.route('/hm/people/inc/')   #++
def hm_inc():
    result = editDB("SELECT people FROM hm_people","get")
    people = result[0]["people"]
    people += 1
    editDB("UPDATE hm_people SET people=" + str(people) + " WHERE id=1","set")
    return str(people)

@app.route('/hm/people/dec/')   #--
def hm_dec():
    result = editDB("SELECT people FROM hm_people", "get")
    people = result[0]["people"]
    if people > 0:
        people -= 1
    elif people < 0:
        people = 0
    editDB("UPDATE hm_people SET people=" + str(people) + " WHERE id=1","set")
    return str(people)

@app.route('/hm/people/now/')
def hm_now():
    result = editDB("SELECT people FROM hm_people","get")
    people = result[0]["people"]
    response = make_response(str(people))
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response

@app.route('/hm/timetable/')
def hm_timetable():
    scr = bus_scr.hmScr()
    print(jsonify(scr))
    #$return json.dumps(scr)
    return jsonify(scr)

@app.route('/h/timetable/')
def h_timetable():
    scr = bus_scr.hScr()
    print(jsonify(scr))
    #$return json.dumps(scr)
    return jsonify(scr)

@app.route('/gk/timetable/')
def gs_timetable():
    scr = bus_scr.gkScr()
    print(jsonify(scr))
    #$return json.dumps(scr)
    return jsonify(scr)

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')