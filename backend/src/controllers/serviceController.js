const Service = require('../model/serviceSchema');

const getServices = async (req, res) => {
    try {
        const filter = { isActive: true };
        if (req.query.category) filter.category = req.query.category;

        const services = await Service.find(filter)
            .populate('provider', 'name email phone profileImage')
            .sort({ createdAt: -1 });

        return res.status(200).json({ services });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch services' });
    }
};

const getServiceById = async (req, res) => {
    try {
        const service = await Service.findById(req.params.id)
            .populate('provider', 'name email phone profileImage providerInfo');

        if (!service || !service.isActive) {
            return res.status(404).json({ message: 'Service not found' });
        }

        return res.status(200).json({ service });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to fetch service' });
    }
};

const createService = async (req, res) => {
    try {
        const { name, description, category, icon, basePrice } = req.body;

        if (!name || !category || basePrice === undefined) {
            return res.status(400).json({ message: 'Name, category and basePrice are required' });
        }

        const service = await Service.create({
            name,
            description: description || '',
            category,
            icon: icon || 'build',
            basePrice,
            provider: req.user.role === 'provider' ? req.user._id : req.body.provider || null,
        });

        return res.status(201).json({ message: 'Service created', service });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to create service' });
    }
};

const updateService = async (req, res) => {
    try {
        const service = await Service.findById(req.params.id);
        if (!service) {
            return res.status(404).json({ message: 'Service not found' });
        }

        if (req.user.role === 'provider' && service.provider?.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'Not authorized' });
        }

        const fields = ['name', 'description', 'category', 'icon', 'basePrice', 'isActive'];
        fields.forEach((field) => {
            if (req.body[field] !== undefined) service[field] = req.body[field];
        });

        await service.save();
        return res.status(200).json({ message: 'Service updated', service });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to update service' });
    }
};

const deleteService = async (req, res) => {
    try {
        const service = await Service.findById(req.params.id);
        if (!service) {
            return res.status(404).json({ message: 'Service not found' });
        }

        service.isActive = false;
        await service.save();

        return res.status(200).json({ message: 'Service deactivated' });
    } catch (error) {
        return res.status(500).json({ message: 'Failed to delete service' });
    }
};

module.exports = {
    getServices,
    getServiceById,
    createService,
    updateService,
    deleteService,
};
