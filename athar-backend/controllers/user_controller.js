const mongoose = require('mongoose');
const userModel = require('../models/user.model');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const getAllUsers = async (req, res) => {
    const userList = await userModel.find().select("-password");
    if (!userList) {
        return res.status(404).json({ message: "No User Found" });
    }
    return res.status(200).json(userList);
};

const getUserById = async (req, res) => {
    try {
        const user = await userModel.findById(req.params.id).select("-password");
        if (!user) {
            return res.status(404).json({ message: "User Not Found" });
        }
        return res.status(200).json(user);
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
};

const createUser = async (req, res) => {
    try {
        const allowedRoles = ["customer", "seller", "admin"];
        const finalRole = allowedRoles.includes(req.body.role) ? req.body.role : "customer";

        const newUser = userModel({
            name: req.body.name,
            email: req.body.email,
            password: bcrypt.hashSync(req.body.password, 10),
            role: finalRole
        });
        const savedUser = await newUser.save();
        return res.status(201).json(savedUser);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to create user",
            details: error.message
        });
    }
};

const updateUserById = async (req, res) => {
    try {
        const updatedUser = await userModel.findByIdAndUpdate(
            req.params.id,
            {
                name: req.body.name,
                email: req.body.email,
                password: bcrypt.hashSync(req.body.password, 10),
                role: req.body.role
            },
            { new: true }
        );
        return res.status(200).json(updatedUser);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to update user",
            details: error.message
        });
    }
};

const deleteUserById = async (req, res) => {
    try {
        const deletedUser = await userModel.findByIdAndDelete(req.params.id);
        if (!deletedUser) {
            return res.status(404).json({ message: "User Not Found " });
        }
        return res.status(200).json({ message: "User Deleted Successfully" });
    } catch (error) {
        return res.status(500).json({
            message: "Failed to delete user",
            details: error.message
        });
    }
};

const loginUser = async (req, res) => {
    try {
        const user = await userModel.findOne({ email: req.body.email });

        if (!user) {
            return res.status(404).json({ message: "User Not Found, Please Register" });
        }

        const isPasswordValid = bcrypt.compareSync(req.body.password, user.password);

        if (!isPasswordValid) {
            return res.status(401).json({ message: "Invalid Password" });
        }

        const secretKey = process.env.JWT_SECRET;
        const token = jwt.sign(
            {
                email: user.email,
                userId: user._id,
                role: user.role
            },
            secretKey,
            { expiresIn: '1w' }
        );

        return res.status(200).json({
            id: user._id,
            email: user.email,
            name: user.name,
            role: user.role,
            image: user.image || '',
            token: token,
        });

    } catch (error) {
        return res.status(500).json({
            message: "Failed to login user",
            details: error.message
        });
    }
};

const registerUser = async (req, res) => {
    try {
        const { name, email, password, role } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({ message: "Name, Email and Password are required" });
        }

        const existingUser = await userModel.findOne({ email: email });

        if (existingUser) {
            return res.status(400).json({ message: "Email already exists, Please login" });
        }

        const allowedRoles = ["customer", "seller"];
        const finalRole = allowedRoles.includes(role) ? role : "customer";

        const newUser = await userModel.create({
            name: name,
            email: email,
            password: bcrypt.hashSync(password, 10),
            role: finalRole
        });

        return res.status(201).json(newUser);
    } catch (error) {
        return res.status(500).json({
            message: "Failed to register user",
            details: error.message
        });
    }
};

// ── جديد: تحديث الملف الشخصي للمستخدم الحالي (اسم/إيميل/صورة) ──
const updateMyProfile = async (req, res) => {
    try {
        const userId = req.user.userId;

        const updateData = {
            name: req.body.name,
            email: req.body.email,
        };

        if (req.body.password && req.body.password.trim() !== '') {
            updateData.password = bcrypt.hashSync(req.body.password, 10);
        }

        if (req.file) {
            updateData.image = req.file.filename;
        }

        const updatedUser = await userModel.findByIdAndUpdate(
            userId,
            updateData,
            { new: true }
        ).select("-password");

        if (!updatedUser) {
            return res.status(404).json({ message: "User Not Found" });
        }

        return res.status(200).json({
            id: updatedUser._id,
            email: updatedUser.email,
            name: updatedUser.name,
            role: updatedUser.role,
            image: updatedUser.image || '',
        });
    } catch (error) {
        return res.status(500).json({
            message: "Failed to update profile",
            details: error.message
        });
    }
};

module.exports = {
    getAllUsers,
    getUserById,
    createUser,
    updateUserById,
    deleteUserById,
    loginUser,
    registerUser,
    updateMyProfile
};