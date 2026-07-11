const jwt = require('jsonwebtoken');
const {unless} = require('express-unless');


const authJwt = (req, res, next) => {

    const authHeader = req.headers.authorization;

    if (!authHeader) {
        return res.status(401).json({ message: "Unauthorized" });
    }

    const token = authHeader.split(' ')[1]; // عشان نفصل بين ال Bearer و ال token

    if (!token) {
        return res.status(401).json({ message: "Token not Provided" });
    }

    try {
        const verified = process.env.JWT_SECRET;
        const user = jwt.verify(token, verified);
        req.user = user;
        next();

    } catch (error) {
        return res.status(401).json({ message: "Invalid Token" });
    }
}

authJwt.unless = unless;
module.exports = authJwt;