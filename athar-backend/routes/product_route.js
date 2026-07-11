const express = require('express');
const router = express.Router();
const productController = require('../controllers/product_controller');
const authJwt = require('../helper/jwt');
const isSeller = require('../helper/is_seller');
const uploads = require('../helper/uploads');
const optionalAuth = require('../helper/optional_auth');

router.get('/', optionalAuth, productController.getAllProducts);

router.get('/base/info', authJwt, productController.getProductWithBaseInfo);
router.get('/base/count', authJwt, productController.getProductCount);

router.get('/:id', productController.getProductById);

router.post('/', authJwt, isSeller, uploads.single("image"), productController.createProduct);
router.post('/uploads', authJwt, isSeller, uploads.single("image"), productController.uploadImage);

router.put('/:id', authJwt, productController.updateProductById);
router.delete('/:id', authJwt, productController.deleteProductById);

module.exports = router;