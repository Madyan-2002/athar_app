const errorHandler = (error, req, res, next) => {

    if (error) {
        return res.status(500).json({
            message: "An error occurred",
        });
    }

    return res.status(500).json({
        message: "An unknown error occurred",
    });
}

module.exports = errorHandler
