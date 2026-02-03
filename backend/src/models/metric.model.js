import mongoose from 'mongoose'


const metricSchema = new mongoose.Schema({
    device: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Device',
        required: true,
        index: true
    },

    //core metrics
    cpu: {
        type: Number,
        required: true,
    },
    memory: {
        used: Number,
        total: Number
    },
    disk: {
        used: Number,
        total: Number
    },

    battery: {
        isCharging: Boolean,
        cycleCount: Number,
        percent: Number
    },

    //dynamic metrics
    extras: {
        type: mongoose.Schema.Types.Mixed,
        default: {}
    }

},{timestamps: true})

metricSchema.index({device: 1, createdAt: -1})
metricSchema.index({createdAt: 1},{expireAfterSeconds: 60*60*24*7})

export const Metric = mongoose.model('Metric',metricSchema)