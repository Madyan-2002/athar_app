const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true,
        minlength: 8
    },
    image: {
        type: String,
        default: ''
    },
    role: {
        type: String,
        enum: ["admin", "seller", "customer"],
        default: 'customer'
    },
    favorites: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Product'
    }],
});

const userModel = mongoose.model('User', userSchema);

module.exports = userModel;