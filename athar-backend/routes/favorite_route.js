const express = require('express');
const router = express.Router();
const favoriteController = require('../controllers/favorite_controller');
const authJwt = require('../helper/jwt');

router.post('/:productId', authJwt, favoriteController.toggleFavorite);
router.get('/ids', authJwt, favoriteController.getMyFavoriteIds);
router.get('/', authJwt, favoriteController.getMyFavoriteProducts);

module.exports = router;