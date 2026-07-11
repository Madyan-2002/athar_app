const mongoose = require('mongoose');
const Order = require('../models/order.model');
const OrderItem = require('../models/orderItem.model');
const orderModel = require('../models/order.model');


// Get All orders
const getAllOrders = async (req, res) => {
    try {
        const orders = await orderModel.find();
        res.status(200).json(orders);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
}

// Create New Order
const createOrder = async (req, res) => {
    try {
        const orderItemIds = await Promise.all(req.body.items.map(async (item) => {
            const newOrderItem = new OrderItem({
                product: item.product,
                quantity: item.quantity
            })
            const savedOrderItem = await newOrderItem.save();

            return savedOrderItem._id;
        }))
        const newOrder = new orderModel({
            user: req.body.user,
            items: orderItemIds,
            totalPrice: req.body.totalPrice,
            status: req.body.status,
            address: req.body.address,
            phone: req.body.phone
        })
        const savedOrder = await newOrder.save();
        console.log(newOrder);
        res.status(201).json(savedOrder);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
}

// Update Order Status
const updateOrderStatus = async (req, res) => {
    try {
        const orderId = req.params.id;
        const newStatus = req.body.status;
        const updatedOrder = await orderModel.findByIdAndUpdate
        (orderId, { status: newStatus}, {
            new: true,
        })
        res.status(200).json(updatedOrder);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
}

// Delete Order By Id

const deleteOrderByID = async (req,res) => {
    try {
        const orderId = req.params.id;
        const deletedOrder = await orderModel.findByIdAndDelete(orderId);

        if(!deletedOrder) {
            return res.status(404).json({ message: "Order Not Found" });
        }
        res.status(200).json({ message: "Order Deleted Successfully" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }

};
module.exports = {
    getAllOrders,
    createOrder,
    updateOrderStatus,
    deleteOrderByID
};
