const express = require('express');
const router = express.Router();
const categoryController = require('../controllers/category_controller');

const categoryModel = require('../models/category.model');

// Get All Categories
router.get('/', categoryController.getAllCategories);

// Get Category By ID
router.get('/:id', categoryController.getCategoryById);

// Create New Category
router.post('/',categoryController.createCategory);

// Update Category By ID
router.put('/:id',categoryController.updateCategoryById);

// Delete Category By ID
router.delete('/:id',categoryController.deleteCategoryById);


module.exports = router;