const express = require('express');
const router = express.Router();
const orderController = require('../controllers/order_controller');
const orderModel = require('../models/order.model');
const authJwt = require('../helper/jwt');


router.post('/', authJwt, orderController.createOrder);
router.get('/', authJwt, orderController.getAllOrders);
router.put('/:id', authJwt, orderController.updateOrderStatus);
router.delete('/:id', authJwt, orderController.deleteOrderByID);

module.exports = router;
