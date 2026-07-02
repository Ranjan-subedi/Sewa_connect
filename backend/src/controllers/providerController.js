const User = require('../model/userSchema');
const Service = require('../model/serviceSchema');
const Booking = require('../model/bookingSchema');

const getProviderDashboard = async (req, res) => {
    try {
        const providerId = req.user._id;

        const [services, bookings, completedJobs, earnings] = await Promise.all([
            Service.find({ provider: providerId, isActive: true }),
            Booking.find({ provider: providerId })
                .populate('service')
                .populate('user', 'name email phone')
                .sort({ createdAt: -1 })
                .limit(10),
            Booking.countDocuments({ provider: providerId, status: 'completed' }),
            Booking.aggregate([
                { $match: { provider: providerId, paymentStatus: 'paid' } },
                { $group: { _id: null, total: { $sum: '$amount' } } },
            ]),
        ]);

        const pendingJobs = await Booking.countDocuments({
            provider: providerId,
            status: { $in: ['pending', 'confirmed', 'in_progress'] },
        });

        return res.status(200).json({
            stats: {
                totalServices: services.length,
                pendingJobs,
                completedJobs,
                totalEarnings: earnings[0]?.total || 0,
            },
            services,
            recentBookings: bookings,
        });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch provider dashboard' });
    }
};

const getProviderServices = async (req, res) => {
    try {
        const services = await Service.find({ provider: req.user._id }).sort({ createdAt: -1 });
        return res.status(200).json({ services });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch services' });
    }
};

const assignBookingToSelf = async (req, res) => {
    try {
        const booking = await Booking.findById(req.params.id);
        if (!booking) {
            return res.status(404).json({ message: 'Booking not found' });
        }

        if (booking.provider) {
            return res.status(400).json({ message: 'Booking already assigned' });
        }

        booking.provider = req.user._id;
        await booking.save();

        const populated = await Booking.findById(booking._id)
            .populate('service')
            .populate('user', 'name email phone');

        return res.status(200).json({ message: 'Booking assigned', booking: populated });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to assign booking' });
    }
};

const getUnassignedBookings = async (req, res) => {
    try {
        const bookings = await Booking.find({ provider: null, status: 'pending' })
            .populate('service')
            .populate('user', 'name email phone')
            .sort({ createdAt: -1 });

        return res.status(200).json({ bookings });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch bookings' });
    }
};

module.exports = {
    getProviderDashboard,
    getProviderServices,
    assignBookingToSelf,
    getUnassignedBookings,
};
