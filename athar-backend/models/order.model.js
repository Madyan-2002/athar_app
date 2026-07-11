// user // product // quantity //total price // status

const mongoose = require('mongoose');
const orderSchema = new mongoose.Schema({

    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    totalPrice: {
        type: Number,
        required: true
    },
    status: {
        type: String,
        default: "pending"
    },
    address: {
        type: String,
        required: true,
    },
    phone: {
        type: String,
        required: true,
    },
    items: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: "OrderItem",
            required: true
        }
    ]
})

const orderModel = mongoose.model('Order', orderSchema);
module.exports = orderModel;


