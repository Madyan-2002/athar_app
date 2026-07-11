const express = require('express');
const router = express.Router();
const feedbackController = require('../controllers/feedback_controller');
const authJwt = require('../helper/jwt');
const isAdmin = require('../helper/is_admin');

// أي مستخدم مسجل دخول يقدر يرسل ملاحظة
router.post('/', authJwt, feedbackController.createFeedback);

// الأدمن بس يشوف الكل ويحذف
router.get('/', authJwt, isAdmin, feedbackController.getAllFeedbacks);
router.delete('/:id', authJwt, isAdmin, feedbackController.deleteFeedbackById);

module.exports = router;