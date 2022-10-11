from .redirector import redirect
from flask import Flask, request, Response, make_response
import requests

#Для локального запуска
ITEMS_PATH = 'http://127.0.0.1:5001/'
CART_PATH = 'http://127.0.0.1:5002/'
USERS_PATH = 'http://127.0.0.1:5003/'
CHECKOUT_PATH = 'http://127.0.0.1:5005/'

#Для docker-compose
# ITEMS_PATH = 'http://catalogue_service:5001/' #для docker-compose
# CART_PATH = 'http://cart_service:5002/'
# USERS_PATH = 'http://auth_service:5003/'
# CHECKOUT_PATH = 'http://checkout_service:5005/'


app = Flask(__name__)


#выполняется перед КАЖДЫМ запросом.
@app.before_request
def check_token():
    print(request.path)
    if('/items/' in request.path):
        return
    else:
        users_full_path = USERS_PATH + 'user/token'
        response = requests.request(
            method='GET',
            url=users_full_path,
            headers={key: value for (key, value) in request.headers if key != 'Host'},
            cookies=request.cookies,
            allow_redirects=False)
        if response.status_code != 200:
            return make_response('check your authorization data', response.status_code, {'Authentication': 'invalid token'})


@app.errorhandler(404)
@app.route("/items/<path>", methods=['GET'])
def item_proxy(path):
    response = redirect(request, ITEMS_PATH)
    return Response(response['content'], response['status_code'], response['headers'])

@app.errorhandler(404)
@app.route("/items/", methods=['GET'])
def items_proxy():
    response = redirect(request, ITEMS_PATH)
    return Response(response['content'], response['status_code'], response['headers'])

@app.errorhandler(404)
@app.route("/cart/items/<path>", methods=['GET', 'DELETE'])
def all_cart_proxy(path):
    response = redirect(request, CART_PATH)
    return Response(response['content'], response['status_code'], response['headers'])

@app.errorhandler(404)
@app.route("/cart/<path>", methods=['GET', 'POST', 'DELETE'])
def cart_proxy(path):
    response = redirect(request, CART_PATH)
    return Response(response['content'], response['status_code'], response['headers'])


@app.errorhandler(404)
@app.route("/checkout/<path>", methods=['GET', 'POST'])
def checkout_proxy(path):
    response = redirect(request, CHECKOUT_PATH)
    return Response(response['content'], response['status_code'], response['headers'])
