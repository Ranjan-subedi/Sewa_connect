const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
    name: { type: String, required: true, trim: true },
    description: { type: String, default: '' },
    category: { type: String, required: true, trim: true },
    icon: { type: String, default: 'build' },
    basePrice: { type: Number, required: true, min: 0 },
    isActive: { type: Boolean, default: true },
    provider: { type: mongoose.Schema.Types.ObjectId, ref: 'users', default: null },
}, { timestamps: true });

module.exports = mongoose.model('services', serviceSchema);
