const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'users', required: true },
    provider: { type: mongoose.Schema.Types.ObjectId, ref: 'users', default: null },
    service: { type: mongoose.Schema.Types.ObjectId, ref: 'services', required: true },
    address: { type: String, required: true },
    scheduledDate: { type: Date, required: true },
    notes: { type: String, default: '' },
    amount: { type: Number, required: true, min: 0 },
    status: {
        type: String,
        enum: ['pending', 'confirmed', 'in_progress', 'completed', 'cancelled'],
        default: 'pending',
    },
    paymentStatus: {
        type: String,
        enum: ['unpaid', 'pending', 'paid', 'failed', 'refunded'],
        default: 'unpaid',
    },
    paymentId: { type: String, default: null },
    pidx: { type: String, default: null },
}, { timestamps: true });

module.exports = mongoose.model('bookings', bookingSchema);
