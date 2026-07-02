const jwt = require('jsonwebtoken');
const User = require('../model/userSchema');
const { createNotification } = require('../services/notificationService');

const signToken = (user) => jwt.sign(
    { id: user._id, role: user.role },
    process.env.JWT_SECRET || 'sewa_connect_secret',
    { expiresIn: '7d' },
);

const registerUser = async (req, res) => {
    try {
        const { name, email, password, phone, role } = req.body;

        if (!name || !email || !password) {
            return res.status(400).json({ message: 'Name, email and password are required' });
        }

        if (password.length < 8) {
            return res.status(400).json({ message: 'Password must be at least 8 characters' });
        }

        const existingUser = await User.findOne({ email: email.toLowerCase() });
        if (existingUser) {
            return res.status(400).json({ message: 'User already exists' });
        }

        const userRole = role === 'provider' ? 'provider' : 'user';
        const newUser = new User({
            name,
            email: email.toLowerCase(),
            password,
            phone: phone || '',
            role: userRole,
            isApproved: userRole !== 'provider',
        });

        await newUser.save();

        if (userRole === 'provider') {
            await createNotification({
                userId: newUser._id,
                title: 'Provider Registration',
                message: 'Your provider account is pending admin approval.',
                type: 'provider',
            });
        }

        const token = signToken(newUser);

        return res.status(201).json({
            message: 'User registered successfully',
            token,
            user: newUser.toSafeObject(),
        });
    } catch (error) {
        return res.status(500).json({ message: error.message || 'Registration failed' });
    }
};

const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Email and password are required' });
        }

        const user = await User.findOne({ email: email.toLowerCase() });
        if (!user) {
            return res.status(400).json({ message: 'User not found' });
        }

        if (user.isBlocked) {
            return res.status(403).json({ message: 'Account is blocked. Contact admin.' });
        }

        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid password' });
        }

        if (user.role === 'provider' && !user.isApproved) {
            return res.status(403).json({ message: 'Provider account pending admin approval' });
        }

        const token = signToken(user);

        return res.status(200).json({
            message: 'Login successful',
            token,
            user: user.toSafeObject(),
        });
    } catch (error) {
        return res.status(500).json({ message: 'Server error' });
    }
};

const getProfile = async (req, res) => {
    return res.status(200).json({ user: req.user.toSafeObject() });
};

const updateProfile = async (req, res) => {
    try {
        const { name, phone, profileImage, providerInfo } = req.body;
        const user = await User.findById(req.user._id);

        if (name) user.name = name;
        if (phone !== undefined) user.phone = phone;
        if (profileImage !== undefined) user.profileImage = profileImage;

        if (req.user.role === 'provider' && providerInfo) {
            user.providerInfo = { ...user.providerInfo.toObject(), ...providerInfo };
        }

        await user.save();

        return res.status(200).json({
            message: 'Profile updated',
            user: user.toSafeObject(),
        });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to update profile' });
    }
};

module.exports = {
    registerUser,
    loginUser,
    getProfile,
    updateProfile,
};
