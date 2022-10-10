from . import db


class CheckoutItem:
    def __init__(self, title: str, imageURL: str) -> None:
        self.title = title
        self.imageURL = imageURL

    def to_dict(self):
        return dict(name=self.title, imageURL=self.imageURL)

class UserOrder(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    userId = db.Column(db.Integer, index=True)
    itemId = db.Column(db.Integer, index=True)
    title = db.Column(db.String(120), index=True)
    price = db.Column(db.Integer, index=True)
    imageURL = db.Column(db.String(), index=True)
    date = db.Column(db.DATE, index=True)

    def to_dict(self):
        return dict(userId=self.userId, itemId=self.itemId, title=self.title, price=self.price, imageURL=self.imageURL, date = self.date)

