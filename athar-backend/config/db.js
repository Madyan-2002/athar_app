const mongoose = require('mongoose');
require('dotenv').config();

const connectDB = async () => {
   try {
        
        await mongoose.connect(process.env.MONGODB_URL);

        console.log("Connect to DataBase ✅");
    }
    catch (error) {
        console.error("Cannot Connect ❌ " + error.message);
    }
};

module.exports = connectDB;