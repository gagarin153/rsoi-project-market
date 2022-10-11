import requests
from flask import jsonify, request

from . import app, db
from .models import CartItem


@app.route("/cart/item", methods=['POST'])
def add_item():
    data = request.get_json()
    userId = data['userId']
    itemId = data['itemId']

    item_full_path = 'http://127.0.0.1:5001/items/' + str(itemId)
    # item_full_path = 'http://catalogue_service:5001/items/' + str(itemId)

    response = requests.request(
        method='GET',
        url=item_full_path,
        headers={key: value for (key, value) in request.headers if key != 'Host'},
        cookies=request.cookies,
        allow_redirects=False)
    content = response.json()

    new_item = CartItem(userId=userId, itemId=itemId, title=content['title'], price=content['price'], imageURL="")

    db.session.add(new_item)
    db.session.commit()
    return jsonify({'ok': 'true'})


@app.route("/cart/item", methods=['DELETE'])
def delete_item():
    data = request.get_json()

    CartItem.query.filter(CartItem.userId == data['userId'], CartItem.itemId == data['itemId']).delete()
    db.session.commit()
    return jsonify({'ok': 'true'})

@app.route("/cart/items/<userId>", methods=['GET'])
def cart_record(userId):
    result_raw = CartItem.query.filter(CartItem.userId == userId)
    result = [item.to_dict() for item in result_raw]
    return jsonify(result)

@app.route("/cart/items/<userId>", methods=['DELETE'])
def delete_cart_record(userId):
    CartItem.query.filter(CartItem.userId == userId).delete()
    db.session.commit()
    return jsonify({'ok': 'true'})

