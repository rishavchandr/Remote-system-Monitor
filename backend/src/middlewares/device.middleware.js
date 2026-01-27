import {Device} from '../models/device.model.js'
import {asyncHandler} from '../utils/asyncHandler.js'
import {ApiError} from '../utils/ApiError.js'

export const deviceAuth = asyncHandler(async (req,res,next)=>{
       const token = req.headers['x-device-token']

       if(!token)
         throw new ApiError(401,"Device Token Missing")


       const device = await Device.findOne({token})

       if(!device)
          throw new ApiError(401,"Device invaild Token")
      
       req.device = device
       next()
})

