import {Metric} from '../models/metric.model.js'
import {asyncHandler} from '../utils/asyncHandler.js'
import {ApiError} from '../utils/ApiError.js'
import {ApiResponse} from '../utils/ApiResponse.js'
import { Device } from '../models/device.model.js'
import mongoose from 'mongoose'


export const ingestMetric = asyncHandler(async(req,res)=>{
        try {
            const {cpu,memory,disk,battery,extras} = req.body
        
            if(cpu === undefined)
                throw new ApiError(400,"Cpu data is required")
    
             if (memory === undefined)
                  throw new ApiError(400, "Memory data is required")
    
            if (disk === undefined)
                    throw new ApiError(400, "Disk data is required")

            if(battery === undefined)
                throw new ApiError(400,"Battery is required")
        
            await Metric.create({
                device: req.device._id,
                cpu,
                memory,
                disk,
                battery,
                extras: extras || {}
            })
        
            req.device.lastSeenAt = new Date()
            await req.device.save()
        
            res.status(201).json(new ApiResponse(200,null,"Metrics ingested Successfully"))
        } catch (error) {
            res.status(500).json(new ApiError(500,"Metrics ingested failed",error))
        }
    
})

export const getMetrics = asyncHandler( async(req,res) =>{
    try {
        const {deviceId} = req.params
        const {from ,to, bucket = 60} = req.query

        const device = await Device.findOne({
            _id: deviceId,
            user: req.user._id
        })

        if(!device)
            throw new ApiError(403,"Acess Denied")
        
        const match = {device: new mongoose.Types.ObjectId(deviceId)}

        if(from || to){
            match.createdAt = {}
            if(from) match.createdAt.$gte = new Date(from)
            if(to) match.createdAt.$lte = new Date(to)
        }

        const metrics = await Metric.aggregate([
            {$match: match},

            {
                $project: {
                    createdAt: 1,
                    cpu: 1,
                    memory: 1,
                    disk: 1,
                    extrasArray: {$objectToArray: '$extras'}
                }
            },

            {
                $addFields: {
                    bucketTime: {
                        $toDate: {
                            $subtract: [
                                {$toLong: "$createdAt"},
                                {$mod: [{$toLong: "$createdAt"},bucket*1000]}
                            ]
                        }
                    }
                }
            },

            {$unwind: {path: "$extrasArray", preserveNullAndEmptyArrays: true}},

            {
                $group:{
                    _id: {
                        time: '$bucketTime',
                        extraKey: '$extrasArray.k'
                    },

                    cpuAvg: { $avg: "$cpu" },
                    cpuMin: { $min: "$cpu" },
                    cpuMax: { $max: "$cpu" },

                    memoryLast: { $last: "$memory" },

                    diskLast: { $last: "$disk" },

                    extraLast: { $last: "$extrasArray.v"}
                }
            },

           {
          $group: {
             _id: "$_id.time",

             cpu: {
                $first: {
                  avg: "$cpuAvg",
                  min: "$cpuMin",
                  max: "$cpuMax"
                }
            },

            memory: {
                $first: {
                    last: "$memoryLast",
                }
             },

           disk: {
                $first: {
                   last: "$diskLast",
                }
            },

           extras: {
                $push: {
                    k: "$_id.extraKey",
                v: {
                    last: "$extraLast"
                   }
                } 
             } 
            }
           },

           {
              $project: {
                     _id: 0,
                      time: "$_id",
                      cpu: 1,
                      memory: 1,
                      disk: 1,
                    extras: { $arrayToObject: "$extras" }
                 }
           },

               { $sort: { time: 1 } }
        ])

        res.status(200).json(new ApiResponse(200,metrics,"Metric response Successfully"))
                               
    } catch (error) {
        res.status(500).json(new ApiError(500,"failed to fetch",error))
    }
})


export const removeMetrics = async(device) => {

     try {
        await Metric.deleteMany({
            device: device._id
        })
     } catch (error) {
        throw error
     }
}