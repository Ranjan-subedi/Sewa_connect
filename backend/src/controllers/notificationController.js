const Notification = require('../model/notificationSchema');

const getNotifications = async (req, res) => {
    try {
        const notifications = await Notification.find({ user: req.user._id })
            .sort({ createdAt: -1 })
            .limit(50);

        const unreadCount = await Notification.countDocuments({
            user: req.user._id,
            isRead: false,
        });

        return res.status(200).json({ notifications, unreadCount });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch notifications' });
    }
};

const markAsRead = async (req, res) => {
    try {
        const notification = await Notification.findOne({
            _id: req.params.id,
            user: req.user._id,
        });

        if (!notification) {
            return res.status(404).json({ message: 'Notification not found' });
        }

        notification.isRead = true;
        await notification.save();

        return res.status(200).json({ message: 'Marked as read', notification });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to update notification' });
    }
};

const markAllAsRead = async (req, res) => {
    try {
        await Notification.updateMany(
            { user: req.user._id, isRead: false },
            { isRead: true },
        );

        return res.status(200).json({ message: 'All notifications marked as read' });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to update notifications' });
    }
};

module.exports = { getNotifications, markAsRead, markAllAsRead };
