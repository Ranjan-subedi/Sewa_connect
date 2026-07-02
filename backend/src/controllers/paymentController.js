const Booking = require('../model/bookingSchema');
const { initiatePayment, verifyPayment } = require('../services/khaltiService');
const { createNotification } = require('../services/notificationService');

const initiateKhaltiPayment = async (req, res) => {
    try {
        const { bookingId } = req.body;

        if (!bookingId) {
            return res.status(400).json({ message: 'Booking ID is required' });
        }

        if (!process.env.KHALTI_SECRET_KEY) {
            return res.status(500).json({ message: 'Khalti is not configured on server' });
        }

        const booking = await Booking.findById(bookingId).populate('service');
        if (!booking) {
            return res.status(404).json({ message: 'Booking not found' });
        }

        if (booking.user.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Not authorized' });
        }

        if (booking.paymentStatus === 'paid') {
            return res.status(400).json({ message: 'Booking already paid' });
        }

        const khaltiResponse = await initiatePayment({
            amount: booking.amount,
            purchaseOrderId: booking._id.toString(),
            purchaseOrderName: `Sewa Connect - ${booking.service.name}`,
            customerInfo: {
                name: req.user.name,
                email: req.user.email,
                phone: req.user.phone,
            },
        });

        booking.paymentStatus = 'pending';
        booking.pidx = khaltiResponse.pidx;
        await booking.save();

        return res.status(200).json({
            message: 'Payment initiated',
            pidx: khaltiResponse.pidx,
            paymentUrl: khaltiResponse.payment_url,
            expiresAt: khaltiResponse.expires_at,
            amount: booking.amount,
            publicKey: process.env.KHALTI_PUBLIC_KEY,
        });
    } catch (error) {
        const message = error.response?.data?.detail
            || error.response?.data?.error_key
            || error.message
            || 'Payment initiation failed';
        return res.status(500).json({ message });
    }
};

const verifyKhaltiPayment = async (req, res) => {
    try {
        const { pidx, bookingId } = req.body;

        if (!pidx || !bookingId) {
            return res.status(400).json({ message: 'pidx and bookingId are required' });
        }

        const booking = await Booking.findById(bookingId).populate('service');
        if (!booking) {
            return res.status(404).json({ message: 'Booking not found' });
        }

        if (booking.user.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Not authorized' });
        }

        const verification = await verifyPayment(pidx);

        if (verification.status !== 'Completed') {
            booking.paymentStatus = 'failed';
            await booking.save();

            await createNotification({
                userId: booking.user,
                title: 'Payment Failed',
                message: 'Your payment was not completed. Please try again.',
                type: 'payment',
                relatedId: booking._id,
            });

            return res.status(400).json({
                message: 'Payment not completed',
                status: verification.status,
            });
        }

        booking.paymentStatus = 'paid';
        booking.paymentId = verification.transaction_id || pidx;
        booking.pidx = pidx;
        if (booking.status === 'pending') {
            booking.status = 'confirmed';
        }
        await booking.save();

        await createNotification({
            userId: booking.user,
            title: 'Payment Successful',
            message: `Payment of Rs. ${booking.amount} for ${booking.service.name} was successful.`,
            type: 'payment',
            relatedId: booking._id,
        });

        if (booking.provider) {
            await createNotification({
                userId: booking.provider,
                title: 'Payment Received',
                message: `Customer paid for ${booking.service.name}. Job is confirmed.`,
                type: 'payment',
                relatedId: booking._id,
            });
        }

        const populated = await Booking.findById(booking._id)
            .populate('service')
            .populate('user', 'name email phone')
            .populate('provider', 'name email phone');

        return res.status(200).json({
            message: 'Payment verified successfully',
            booking: populated,
            transactionId: verification.transaction_id,
        });
    } catch (error) {
        const message = error.response?.data?.detail
            || error.message
            || 'Payment verification failed';
        return res.status(500).json({ message });
    }
};

module.exports = { initiateKhaltiPayment, verifyKhaltiPayment };
