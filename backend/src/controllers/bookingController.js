const Booking = require('../model/bookingSchema');
const Service = require('../model/serviceSchema');
const User = require('../model/userSchema');
const { createNotification } = require('../services/notificationService');

const createBooking = async (req, res) => {
    try {
        const { serviceId, address, scheduledDate, notes } = req.body;

        if (!serviceId || !address || !scheduledDate) {
            return res.status(400).json({ message: 'Service, address and scheduled date are required' });
        }

        const service = await Service.findById(serviceId);
        if (!service || !service.isActive) {
            return res.status(404).json({ message: 'Service not found' });
        }

        const booking = await Booking.create({
            user: req.user._id,
            provider: service.provider,
            service: serviceId,
            address,
            scheduledDate: new Date(scheduledDate),
            notes: notes || '',
            amount: service.basePrice,
        });

        await createNotification({
            userId: req.user._id,
            title: 'Booking Created',
            message: `Your booking for ${service.name} has been created. Proceed to payment.`,
            type: 'booking',
            relatedId: booking._id,
        });

        if (service.provider) {
            await createNotification({
                userId: service.provider,
                title: 'New Booking Request',
                message: `New booking request for ${service.name}`,
                type: 'booking',
                relatedId: booking._id,
            });
        }

        const populated = await Booking.findById(booking._id)
            .populate('service')
            .populate('user', 'name email phone')
            .populate('provider', 'name email phone');

        return res.status(201).json({ message: 'Booking created', booking: populated });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to create booking' });
    }
};

const getMyBookings = async (req, res) => {
    try {
        const bookings = await Booking.find({ user: req.user._id })
            .populate('service')
            .populate('provider', 'name email phone profileImage')
            .sort({ createdAt: -1 });

        return res.status(200).json({ bookings });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch bookings' });
    }
};

const getBookingById = async (req, res) => {
    try {
        const booking = await Booking.findById(req.params.id)
            .populate('service')
            .populate('user', 'name email phone')
            .populate('provider', 'name email phone profileImage');

        if (!booking) {
            return res.status(404).json({ message: 'Booking not found' });
        }

        const isOwner = booking.user._id.toString() === req.user._id.toString();
        const isProvider = booking.provider && booking.provider._id.toString() === req.user._id.toString();
        const isAdmin = req.user.role === 'admin';

        if (!isOwner && !isProvider && !isAdmin) {
            return res.status(403).json({ message: 'Access denied' });
        }

        return res.status(200).json({ booking });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch booking' });
    }
};

const updateBookingStatus = async (req, res) => {
    try {
        const { status } = req.body;
        const validStatuses = ['pending', 'confirmed', 'in_progress', 'completed', 'cancelled'];

        if (!validStatuses.includes(status)) {
            return res.status(400).json({ message: 'Invalid status' });
        }

        const booking = await Booking.findById(req.params.id).populate('service');
        if (!booking) {
            return res.status(404).json({ message: 'Booking not found' });
        }

        const isProvider = booking.provider?.toString() === req.user._id.toString();
        const isAdmin = req.user.role === 'admin';
        const isOwner = booking.user.toString() === req.user._id.toString();

        if (status === 'cancelled' && !isOwner && !isAdmin) {
            return res.status(403).json({ message: 'Only user or admin can cancel' });
        }

        if (['confirmed', 'in_progress', 'completed'].includes(status) && !isProvider && !isAdmin) {
            return res.status(403).json({ message: 'Only provider or admin can update job status' });
        }

        booking.status = status;
        await booking.save();

        await createNotification({
            userId: booking.user,
            title: 'Booking Updated',
            message: `Your booking status is now: ${status.replace('_', ' ')}`,
            type: 'booking',
            relatedId: booking._id,
        });

        if (status === 'completed' && booking.provider) {
            await User.findByIdAndUpdate(booking.provider, {
                $inc: { 'providerInfo.totalJobs': 1 },
            });
        }

        const populated = await Booking.findById(booking._id)
            .populate('service')
            .populate('user', 'name email phone')
            .populate('provider', 'name email phone');

        return res.status(200).json({ message: 'Booking updated', booking: populated });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to update booking' });
    }
};

const getProviderBookings = async (req, res) => {
    try {
        const bookings = await Booking.find({ provider: req.user._id })
            .populate('service')
            .populate('user', 'name email phone')
            .sort({ createdAt: -1 });

        return res.status(200).json({ bookings });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch provider bookings' });
    }
};

const getAllBookings = async (req, res) => {
    try {
        const bookings = await Booking.find()
            .populate('service')
            .populate('user', 'name email phone')
            .populate('provider', 'name email phone')
            .sort({ createdAt: -1 });

        return res.status(200).json({ bookings });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch bookings' });
    }
};

module.exports = {
    createBooking,
    getMyBookings,
    getBookingById,
    updateBookingStatus,
    getProviderBookings,
    getAllBookings,
};
