import uuid
import jwt
import datetime
from flask import jsonify, make_response, request
from werkzeug.security import generate_password_hash, check_password_hash
from .models import User
from . import app, db


@app.route('/user/token', methods=['GET', 'POST'])
def check_token():
    token = None
    if 'x-access-tokens' in request.headers:
        token = request.headers['x-access-tokens']

    if not token:
        return make_response('could not verify token', 403, {'Authentication': 'token missing'})
    try:

        data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
        current_user = User.query.filter_by(public_id=data['public_id']).first()
        return jsonify({'user': current_user.to_dict()})
    except Exception as e:
        print(e)
        return make_response('could not verify token', 403, {'Authentication': 'invalid token'})


@app.route('/user/register/', methods=['POST'])
def sign_up():
    data = request.get_json()
    hashed_password = generate_password_hash(data['password'], method='sha256')

    new_user = User(public_id=str(uuid.uuid4()), name=data['name'], password=hashed_password, admin=False)
    db.session.add(new_user)
    db.session.commit()
    return jsonify({'message': 'registered successfully'})


@app.route('/user/login/', methods=['POST'])
def sign_in():
    auth = request.authorization

    if not auth or not auth.username or not auth.password:
        return make_response('could not verify', 401, {'Authentication': 'login required"'})

    user = User.query.filter_by(name=auth.username).first()
    if check_password_hash(user.password, auth.password):
        token = jwt.encode(
            {'public_id': user.public_id, 'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=45)},
            app.config['SECRET_KEY'], "HS256")

        return jsonify({'token': token, 'public_id': user.public_id})

    return make_response('could not verify', 401, {'Authentication': 'login required'})
