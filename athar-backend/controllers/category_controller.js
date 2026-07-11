const mongoose = require('mongoose');
const categoryModel = require('../models/category.model');

// Get All Categories
const getAllCategories = async (req, res) => {
    const categoryList = await categoryModel.find();
    if (!categoryList) {
        return res.status(404).json({ message: "No Category Found" });
    }
    return res.status(200).json(categoryList);
};

// Get Category By ID
const getCategoryById = async (req, res) => {
    try {
        const categoryId = await categoryModel.findById(req.params.id);
        if (!categoryId) {
            return res.status(404).json({ message: "Category Not Found" });
        }
        return res.status(200).json(categoryId);
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
};

// Create New Category
const createCategory =  async (req, res) => {
    try {
        const newCategory = categoryModel({
            name: req.body.name
        })
        const savedCategory = await newCategory.save();
        return res.status(201).json(savedCategory);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to create category",
            details: error.message
        });
    }
};

// Update Category By ID
const updateCategoryById =  async (req, res) => {
    try {
        const updatedCategory = await categoryModel.findByIdAndUpdate(
            req.params.id,
            {
                name: req.body.name
            },
            { new: true }
        );
        if (!updatedCategory) {
            return res.status(404).json({ message: "Category Not Found" });
        }
        return res.status(200).json(updatedCategory);
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
};

// Delete Category By ID
const deleteCategoryById = async (req, res) => {
    try {
        const deletedCategory = await categoryModel.findByIdAndDelete(req.params.id);
        if (!deletedCategory) {
            return res.status(404).json({ message: "Category Not Found" });
        }
        return res.status(200).json({ message: "Category Deleted Successfully" });
    }
    catch (error) {
        return res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getAllCategories,
    getCategoryById,
    createCategory,
    updateCategoryById,
    deleteCategoryById
};