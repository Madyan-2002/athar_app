const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');
const cloudinary = require('../config/cloudinary');

const storage = new CloudinaryStorage({
    cloudinary: cloudinary,
    params: {
        folder: 'alkher',
        allowed_formats: ['jpg', 'png', 'jpeg'],
    },
});

const uploads = multer({ storage: storage });

module.exports = uploads;