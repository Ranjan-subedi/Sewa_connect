const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true,
    },
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        trim: true,
    },
    password: {
        type: String,
        required: true,
        minlength: 8,
    },
    phone: {
        type: String,
        default: '',
    },
    role: {
        type: String,
        enum: ['user', 'provider', 'admin'],
        default: 'user',
    },
    profileImage: {
        type: String,
        default: '',
    },
    isApproved: {
        type: Boolean,
        default: true,
    },
    isBlocked: {
        type: Boolean,
        default: false,
    },
    providerInfo: {
        skills: [{ type: String }],
        experience: { type: String, default: '' },
        rating: { type: Number, default: 0 },
        totalJobs: { type: Number, default: 0 },
    },
}, { timestamps: true });

userSchema.pre('save', async function hashPassword() {
    if (!this.isModified('password')) return;
    this.password = await bcrypt.hash(this.password, 10);
});

userSchema.methods.comparePassword = function comparePassword(candidate) {
    return bcrypt.compare(candidate, this.password);
};

userSchema.methods.toSafeObject = function toSafeObject() {
    return {
        _id: this._id,
        name: this.name,
        email: this.email,
        phone: this.phone,
        role: this.role,
        profileImage: this.profileImage,
        isApproved: this.isApproved,
        providerInfo: this.providerInfo,
        createdAt: this.createdAt,
    };
};

module.exports = mongoose.model('users', userSchema);
