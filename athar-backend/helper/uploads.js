// كود مقترح لملف helper/uploads.js باستخدام multer
const multer = require('multer');
const path = require('path');

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // المجلد الذي ستُحفظ فيه الصور
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
    }
});

const uploadOptions = multer({ storage: storage });
module.exports = uploadOptions;