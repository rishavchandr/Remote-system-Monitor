import mongoose from 'mongoose'

const deviceSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    token: {
        type: String,
        required: true,
        unique: true
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    lastSeenAt: {
        type: Date
    }

},{timestamps: true})


export const Device = mongoose.model('Device',deviceSchema)