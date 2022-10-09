from . import db


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    public_id = db.Column(db.Integer)
    name = db.Column(db.String(50))
    password = db.Column(db.String(50))
    admin = db.Column(db.Boolean)

    def __repr__(self):
       return self.name

    def to_dict(self):
        return dict(id=self.id, public_id=self.public_id, name=self.name, password=self.password)
