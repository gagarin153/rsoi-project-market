from .optionsMock import options_mock
import requests
from datetime import date
from flask import jsonify, request

from . import app, db
from .models import CheckoutItem, UserOrder


@app.route("/checkout/options/<userId>", methods=['GET'])
def options(userId):
    #cart_items_full_path = 'http://127.0.0.1:5002/cart/items/' + str(userId)
    cart_items_full_path = 'http://cart_service:5002/cart/items/' + str(userId)

    response = requests.request(
        method='GET',
        url=cart_items_full_path,
        headers={key: value for (key, value) in request.headers if key != 'Host'},
        cookies=request.cookies,
        allow_redirects=False)
    body = response.json()
    items = []
    total_price = 0

    for item in body:
        items.append(CheckoutItem(title=item['title'], imageURL=item['imageURL']).to_dict())
        total_price += item['price']

    return jsonify({'items': items, 'totalPrice': total_price, **options_mock()})

@app.route("/checkout/order/<userId>", methods=['POST'])
def order(userId):
    #cart_items_full_path = 'http://127.0.0.1:5002/cart/items/' + str(userId)
    cart_items_full_path = 'http://cart_service:5002/cart/items/' + str(userId)

    response = requests.request(
        method='GET',
        url=cart_items_full_path,
        headers={key: value for (key, value) in request.headers if key != 'Host'},
        cookies=request.cookies,
        allow_redirects=False)
    body = response.json()
    items = []

    for item in body:
        user_order = UserOrder(userId=userId, itemId=item['itemId'], title=item['title'], price=item['price'], imageURL=item['imageURL'], date=date.today())
        items.append(user_order)

    db.session.add_all(items)
    db.session.commit()

    requests.request(
        method='DELETE',
        url=cart_items_full_path,
        headers={key: value for (key, value) in request.headers if key != 'Host'},
        cookies=request.cookies,
        allow_redirects=False)

    return jsonify({'ok': 'true'})

@app.route("/checkout/userOrders/<userId>", methods=['GET'])
def cart_record(userId):
    result_raw = UserOrder.query.filter(UserOrder.userId == userId)
    result = [item.to_dict() for item in result_raw]
    return jsonify(result)