
from flask import jsonify, request

from . import app, db
from .models import Item


#from . import db
# with app.app_context():
#     i = Item(title='tomato', price=123, rating=10)
#     i2 = Item(title='potato', price=1230, rating=6)
#     db.session.add(i)
#     db.session.add(i2)
#     db.session.commit()
#служебная ручка для товаров
@app.route("/add-item", methods=['POST'])
def add_item():
    data = request.get_json()

    new_item = Item(title=data['title'], price=data['price'], rating=data['rating'], amount=data['amount'], type=data['type'], imageURL=data['imageURL'])
    db.session.add(new_item)
    db.session.commit()
    return jsonify({'ok': 'true'})



@app.route("/", methods=['GET'])
def index():
    return jsonify({
        "uri": "/",
        "subresource_uris": {
            "items": "/items",
            "item": "/items/<id>"
        }
    })


@app.route("/items/<itemid>", methods=['GET'])
def item_info(itemid):
    result = Item.query.get_or_404(itemid).to_dict()
    result["uri"] = f"/items/{itemid}"

    return jsonify(result)


@app.route("/items/", methods=['GET'])
def item_record():
    result_raw = Item.query.all()
    result = [item.to_dict() for item in result_raw]
    return jsonify(result)

