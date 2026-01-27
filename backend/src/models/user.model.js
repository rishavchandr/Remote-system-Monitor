import mongoose from 'mongoose'

const userSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique: true,
        lowecase: true
    },
    passwordHash: {
        type: String,
        required: true,
    },
    
    token: {
        type: String
    }
},{timestamps: true})

userSchema.metho

export const User = mongoose.model('User',userSchema)