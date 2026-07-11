const express = require('express');
const app = express();
const mongoose = require('mongoose');
const path = require('path');
const connectDb = require('./config/db');
const bodyParser = require('body-parser');
const authJwt = require('./helper/jwt');
const errorHandler = require('./helper/error_handler');

// Routes
const userRoute = require('./routes/user_route');
const productRoute = require('./routes/product_route');
const categoryRoute = require('./routes/category_route');
const orderRoute = require('./routes/order_route');
const favoriteRoute = require('./routes/favorite_route');
const feedbackRoute = require('./routes/feedback_route');


require('dotenv').config();
const port = process.env.PORT || 3000;
const api = process.env.API_URL;
connectDb();

// Middleware
app.use(express.json());
app.use(bodyParser.json());
app.use(`${api}/uploads`, express.static(path.join(__dirname, "uploads")));

// Routes اللي ما بتحتاج توكن عام (كل وحدة فيها حماية داخلية لو محتاجة)
app.use(`${api}/categories`, categoryRoute);
app.use(`${api}/order`, orderRoute);
app.use(`${api}/favorites`, favoriteRoute);

app.use(`${api}/feedbacks`, feedbackRoute);

// Middleware التحقق من التوكن (يستثني تسجيل الدخول/التسجيل وعرض المنتجات العام)
app.use(authJwt.unless({
  path: [
    `${api}/users/login`,
    `${api}/users/register`,
  ]
}));

app.use(`${api}/users`, userRoute);
app.use(`${api}/products`, productRoute);

app.use(errorHandler);

app.listen(port, () => {
  console.log(`midProject app running on port ${port}`);
});