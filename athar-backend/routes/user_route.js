const express = require('express');
const router = express.Router();
const userModel = require('../models/user.model');
const userController = require('../controllers/user_controller');
const authJwt = require('../helper/jwt');
const uploads = require('../helper/uploads');
const isAdmin = require('../helper/is_admin');

// تسجيل الدخول وإنشاء حساب جديد
router.post('/login', userController.loginUser);
router.post('/register', userController.registerUser);

// جلب جميع المستخدمين
router.get('/', authJwt, isAdmin, userController.getAllUsers);

// جلب مستخدم معين عن طريق الـ ID
router.get('/:id', authJwt, userController.getUserById);

// إنشاء مستخدم جديد (من قبل المسؤول)
router.post('/', userController.createUser);

router.put('/update-profile', authJwt, uploads.single('image'), userController.updateMyProfile);

// تحديث مستخدم معين عن طريق الـ ID (للأدمن)
router.put('/:id', authJwt, userController.updateUserById);

// حذف مستخدم عن طريق الـ ID
router.delete('/:id', authJwt, isAdmin, userController.deleteUserById);

module.exports = router;