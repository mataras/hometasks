#!/usr/bin/python3

from flask import Flask, request
import emoji
app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def requests():
    if request.method == 'POST':
        request_data = request.get_json(force=True)
        smile = emoji.emojize(":grinning_face_with_big_eyes:")
        if request_data:
            if 'word' in request_data:
                word = request_data['word']
            if 'count' in request_data:
                count = request_data['count']
        return (smile + word)*count + smile
    else:
        return 'GET_request'
if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port = 80)
