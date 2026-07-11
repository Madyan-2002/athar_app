const isSeller = (req, res, next) => {
    if (req.user.role !== 'seller') {
        return res.status(403).json({ message: "Forbidden - Sellers only" });
    }
    next();
};

module.exports = isSeller;