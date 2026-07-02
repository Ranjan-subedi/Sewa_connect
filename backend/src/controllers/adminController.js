const User = require('../model/userSchema');
const Service = require('../model/serviceSchema');
const Booking = require('../model/bookingSchema');
const { createNotification } = require('../services/notificationService');

const getDashboardStats = async (req, res) => {
    try {
        const [totalUsers, totalProviders, totalServices, totalBookings, pendingProviders] = await Promise.all([
            User.countDocuments({ role: 'user' }),
            User.countDocuments({ role: 'provider', isApproved: true }),
            Service.countDocuments({ isActive: true }),
            Booking.countDocuments(),
            User.countDocuments({ role: 'provider', isApproved: false }),
        ]);

        const revenue = await Booking.aggregate([
            { $match: { paymentStatus: 'paid' } },
            { $group: { _id: null, total: { $sum: '$amount' } } },
        ]);

        return res.status(200).json({
            stats: {
                totalUsers,
                totalProviders,
                totalServices,
                totalBookings,
                pendingProviders,
                totalRevenue: revenue[0]?.total || 0,
            },
        });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch dashboard stats' });
    }
};

const getAllUsers = async (req, res) => {
    try {
        const filter = {};
        if (req.query.role) filter.role = req.query.role;

        const users = await User.find(filter)
            .select('-password')
            .sort({ createdAt: -1 });

        return res.status(200).json({ users });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch users' });
    }
};

const approveProvider = async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user || user.role !== 'provider') {
            return res.status(404).json({ message: 'Provider not found' });
        }

        user.isApproved = true;
        await user.save();

        await createNotification({
            userId: user._id,
            title: 'Account Approved',
            message: 'Your provider account has been approved. You can now accept jobs.',
            type: 'provider',
        });

        return res.status(200).json({ message: 'Provider approved', user: user.toSafeObject() });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to approve provider' });
    }
};

const toggleBlockUser = async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        if (user.role === 'admin') {
            return res.status(400).json({ message: 'Cannot block admin account' });
        }

        user.isBlocked = !user.isBlocked;
        await user.save();

        return res.status(200).json({
            message: user.isBlocked ? 'User blocked' : 'User unblocked',
            user: user.toSafeObject(),
        });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to update user' });
    }
};

const deleteUser = async (req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        if (user.role === 'admin') {
            return res.status(400).json({ message: 'Cannot delete admin account' });
        }

        await User.findByIdAndDelete(req.params.id);
        return res.status(200).json({ message: 'User deleted' });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to delete user' });
    }
};

module.exports = {
    getDashboardStats,
    getAllUsers,
    approveProvider,
    toggleBlockUser,
    deleteUser,
};
