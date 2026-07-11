const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true
    },

    description: {
        type: String,
    },

    type: {
        type: String,
        enum: ['sell', 'donation', 'job', 'other'],
        required: true
    },

    price: {
        type: Number,
        required: function () {
            return this.type === 'sell';
        }
    },

    stock: {
        type: Number,
        default: 0
    },

    category: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Category",
        required: function () {
            return this.type === 'sell';
        }
    },
    contactNumber: {
        type: String,
        required: true
    },
    // donation
    targetAmount: {
        type: Number
    },
    deadline: {
        type: Date
    },
    // job
    salary: {
        type: Number
    },
    location: {
        type: String
    },
    image: {
        type: [String],
        required: true
    },
    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
}, { timestamps: true });

module.exports = mongoose.model('Product', productSchema);