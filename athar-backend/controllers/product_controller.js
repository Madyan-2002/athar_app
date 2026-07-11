const mongoose = require('mongoose');
const productModel = require('../models/product.model');

const getAllProducts = async (req, res) => {
    try {
        let filter = {};

        if (req.query.category) {
            filter.category = { $in: req.query.category.split(',') };
        }

        if (req.query.type) {
            filter.type = req.query.type;
        }

        if (req.query.mine === 'true') {
            if (!req.user) {
                return res.status(401).json({ message: "Unauthorized" });
            }
            filter.createdBy = req.user.userId;
        }

        const productList = await productModel
            .find(filter)
            .populate('category', 'name')
            .populate('createdBy', 'name email role');

        return res.status(200).json(productList);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to fetch products",
            details: error.message
        });
    }
};

const getProductById = async (req, res) => {
    const isValid = mongoose.isValidObjectId(req.params.id);
    if (!isValid) {
        return res.status(400).json({ message: "Invalid Product ID" });
    }
    try {
        const product = await productModel
            .findById(req.params.id)
            .populate('category', 'name')
            .populate('createdBy', 'name email role');
        if (!product) {
            return res.status(404).json({ message: "Product Not Found" });
        }
        return res.status(200).json(product);
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
};

const getProductWithBaseInfo = async (req, res) => {
    const productWithBaseInfo = await productModel.find().select('title -_id');
    if (!productWithBaseInfo) {
        return res.status(404).json({ message: "No Product Found" });
    }
    return res.status(200).json(productWithBaseInfo);
};

const getProductCount = async (req, res) => {
    const productCount = await productModel.countDocuments();
    if (!productCount) {
        return res.status(404).json({ message: "No Product Found" });
    }
    return res.status(200).json({ count: productCount });
};

const createProduct = async (req, res) => {
    try {
        const allowedTypes = ['sell', 'donation', 'job', 'other'];
        if (!allowedTypes.includes(req.body.type)) {
            return res.status(400).json({ message: "Invalid product type" });
        }

        const newProduct = productModel({
            title: req.body.title,
            description: req.body.description,
            type: req.body.type,
            price: req.body.price || undefined,
            stock: req.body.stock || undefined,
            category: req.body.category || undefined,
            targetAmount: req.body.targetAmount || undefined,
            deadline: req.body.deadline || undefined,
            salary: req.body.salary || undefined,
            location: req.body.location || undefined,
            image: req.file ? [req.file.filename] : [],
            createdBy: req.user.userId,
            contactNumber: req.body.contactNumber,
        });

        const savedProduct = await newProduct.save();
        return res.status(201).json(savedProduct);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to create product",
            details: error.message
        });
    }
};

const updateProductById = async (req, res) => {
    try {
        const product = await productModel.findById(req.params.id);
        if (!product) {
            return res.status(404).json({ message: "Product Not Found" });
        }

        const isOwner = product.createdBy.toString() === req.user.userId;
        const isAdmin = req.user.role === 'admin';
        if (!isOwner && !isAdmin) {
            return res.status(403).json({ message: "ليس لديك صلاحية تعديل هذا الإعلان" });
        }

        const updatedProduct = await productModel.findByIdAndUpdate(
            req.params.id,
            {
                title: req.body.title,
                description: req.body.description,
                price: req.body.price,
                stock: req.body.stock,
                category: req.body.category,
                targetAmount: req.body.targetAmount,
                deadline: req.body.deadline,
                salary: req.body.salary,
                location: req.body.location,
            },
            { new: true }
        );

        return res.status(200).json(updatedProduct);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to update product",
            details: error.message
        });
    }
};

const deleteProductById = async (req, res) => {
    try {
        const product = await productModel.findById(req.params.id);
        if (!product) {
            return res.status(404).json({ message: "Product Not Found" });
        }

        const isOwner = product.createdBy.toString() === req.user.userId;
        const isAdmin = req.user.role === 'admin';
        if (!isOwner && !isAdmin) {
            return res.status(403).json({ message: "ليس لديك صلاحية حذف هذا الإعلان" });
        }

        await productModel.findByIdAndDelete(req.params.id);
        return res.status(200).json({ message: "Product Deleted Successfully" });
    } catch (error) {
        return res.status(500).json({
            message: "Failed to delete product",
            details: error.message
        });
    }
};

const uploadImage = (req, res) => {
    res.json({ image: req.file.fieldname });
};

module.exports = {
    getAllProducts,
    getProductById,
    getProductWithBaseInfo,
    getProductCount,
    createProduct,
    updateProductById,
    deleteProductById,
    uploadImage
};