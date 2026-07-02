const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true },
    title: { type: String, required: true },
    message: { type: String, required: true },
    type: {
        type: String,
        enum: ['booking', 'payment', 'system', 'provider'],
        default: 'system',
    },
    relatedId: { type: mongoose.Schema.Types.ObjectId, default: null },
    isRead: { type: Boolean, default: false },
}, { timestamps: true });

module.exports = mongoose.model('notifications', notificationSchema);
