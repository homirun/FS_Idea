from flask import Flask, render_template, make_response, jsonify
import sys
import mysql.connector
import datetime
import bus_scr
import json

app = Flask(__name__)

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

@app.route('/')
def hello():
    name = "BUS API!!!!!!"
    return name

@app.route('/people/count/hm/')
def count():
    return render_template('bus_count.html',titlename="count")
@app.route('/people/inc/hm/')   #++
def hm_inc():
    result = editDB("SELECT people FROM hm_people","get")
    people = result[0]["people"]
    people += 1
    editDB("UPDATE hm_people SET people=" + str(people) + " WHERE id=1","set")
    return str(people)

@app.route('/people/dec/hm')   #--
def hm_dec():
    result = editDB("SELECT people FROM hm_people", "get")
    people = result[0]["people"]
    if people > 0:
        people -= 1
    elif people < 0:
        people = 0
    editDB("UPDATE hm_people SET people=" + str(people) + " WHERE id=1","set")
    return str(people)

@app.route('/people/now/hm/')
def hm_now():
    result = editDB("SELECT people FROM hm_people","get")
    people = result[0]["people"]
    response = make_response(str(people))
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response

@app.route('/timetable/hm/')
def hm_timetable():
    scr = bus_scr.getTimeTable("hm")
    return jsonify(scr)

@app.route('/timetable/h/')
def h_timetable():
    scr = bus_scr.getTimeTable("h")
    return jsonify(scr)

@app.route('/timetable/gk/')
def gs_timetable():
    scr = bus_scr.getTimeTable("gk")
    return jsonify(scr)

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')