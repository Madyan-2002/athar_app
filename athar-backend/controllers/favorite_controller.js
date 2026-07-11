const userModel = require('../models/user.model');

// تبديل حالة المفضلة (إضافة لو مش موجودة، حذف لو موجودة)
const toggleFavorite = async (req, res) => {
    try {
        const userId = req.user.userId;
        const productId = req.params.productId;

        const user = await userModel.findById(userId);
        if (!user) {
            return res.status(404).json({ message: "User Not Found" });
        }

        const index = user.favorites.findIndex(
            (id) => id.toString() === productId
        );

        let isFavorite;
        if (index > -1) {
            user.favorites.splice(index, 1);
            isFavorite = false;
        } else {
            user.favorites.push(productId);
            isFavorite = true;
        }

        await user.save();

        return res.status(200).json({ isFavorite });
    } catch (error) {
        return res.status(500).json({
            message: "Failed to toggle favorite",
            details: error.message
        });
    }
};

// جلب كل الـ IDs المفضلة للمستخدم الحالي
const getMyFavoriteIds = async (req, res) => {
    try {
        const user = await userModel.findById(req.user.userId).select('favorites');
        if (!user) {
            return res.status(404).json({ message: "User Not Found" });
        }
        return res.status(200).json(user.favorites);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to fetch favorites",
            details: error.message
        });
    }
};

// جلب المنتجات المفضلة كاملة
const getMyFavoriteProducts = async (req, res) => {
    try {
        const user = await userModel.findById(req.user.userId).populate({
            path: 'favorites',
            populate: { path: 'category', select: 'name' }
        });
        if (!user) {
            return res.status(404).json({ message: "User Not Found" });
        }
        return res.status(200).json(user.favorites);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to fetch favorite products",
            details: error.message
        });
    }
};

module.exports = {
    toggleFavorite,
    getMyFavoriteIds,
    getMyFavoriteProducts
};