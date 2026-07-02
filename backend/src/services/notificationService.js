const Notification = require('../model/notificationSchema');

const createNotification = async ({ userId, title, message, type = 'system', relatedId = null }) => {
    return Notification.create({
        user: userId,
        title,
        message,
        type,
        relatedId,
    });
};

module.exports = { createNotification };
