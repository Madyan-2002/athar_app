const feedbackModel = require('../models/feedback.model');

const createFeedback = async (req, res) => {
    try {
        if (!req.body.message || req.body.message.trim() === '') {
            return res.status(400).json({ message: "الرسالة مطلوبة" });
        }

        const newFeedback = await feedbackModel.create({
            message: req.body.message,
            rating: req.body.rating,
            createdBy: req.user.userId,
        });

        return res.status(201).json(newFeedback);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to create feedback",
            details: error.message
        });
    }
};

const getAllFeedbacks = async (req, res) => {
    try {
        const feedbacks = await feedbackModel
            .find()
            .populate('createdBy', 'name email role')
            .sort({ createdAt: -1 });

        return res.status(200).json(feedbacks);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to fetch feedbacks",
            details: error.message
        });
    }
};

const deleteFeedbackById = async (req, res) => {
    try {
        const deleted = await feedbackModel.findByIdAndDelete(req.params.id);
        if (!deleted) {
            return res.status(404).json({ message: "Feedback Not Found" });
        }
        return res.status(200).json({ message: "Feedback Deleted Successfully" });
    } catch (error) {
        return res.status(500).json({
            message: "Failed to delete feedback",
            details: error.message
        });
    }
};

module.exports = {
    createFeedback,
    getAllFeedbacks,
    deleteFeedbackById
};