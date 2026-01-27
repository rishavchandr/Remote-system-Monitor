import crypto from 'crypto'
import {Device} from '../models/device.model.js'
import {asyncHandler} from '../utils/asyncHandler.js'
import {ApiError} from '../utils/ApiError.js'
import {ApiResponse} from '../utils/ApiResponse.js'


export const registerDevice = asyncHandler( async (req,res) =>{
    const {name} = req.body;
    
    if(!name)
        throw new ApiError(400,"Device Name Required");

    const token = crypto.randomBytes(32).toString('hex')

    const device = await Device.create({
        name,
        token,
        user: req.user._id
    })

    res.status(201).json(new ApiResponse(201,{
       device
    }))
})

export const listDevices = asyncHandler(async(req,res)=>{
    const devices = await Device.find({user: req.user._id})
    res.json(devices)
})

export const removeDevice = asyncHandler(async(req,res)=>{

    const {deviceId} = req.params;

    const device = await Device.findByIdAndDelete({
        _id: deviceId,
        user: req.user._id
    })

    if(!device)
        throw new ApiError(404,"Device doesnot exist")

    await Device.findByIdAndDelete(deviceId)

    res.status(200).json(new ApiResponse(200,{},"Device Removed succesfully"))

})